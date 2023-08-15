# frozen_string_literal: true

# this service can "turn off" the application by:
#   1. showing an "application offline" message for any page request
#   2. turning off the RDS database (to save money)
# for #1, we leverage the infrastructure in place for `capistrano/maintenance`
# where the webserver (apache) has been configured to always show the file at
# `public/system/maintenance.html` instead of the application if that file
# exists.
#
# in order to give the server the right permissions to do these operations,
# an IAM Role has been attached to the EC2 instance. that role has a policy
# set that allows it to (only) start and stop its specific RDS instance.
#
# Tempus Task #242924
# Downtime will be temporarily skipped on production until October 1, 2023
class DowntimeSetter
  def self.turn_off_database
    return log_skip_reason('db shutdown') if skip_shutdown?

    log.info('Starting to turn off database.')
    status = stop_database
    log.info("New database status: #{status}")
  rescue StandardError => e
    log.error("Error encountered: #{e.inspect}")
    log.error(e.backtrace.join("\n"))
  end

  def self.turn_off_application
    return log_skip_reason('app shutdown') if skip_shutdown?

    log.info('Starting to put app into downtime.')
    show_downtime_message
    log.info('Application put into downtime.')
  rescue StandardError => e
    log.error("Error encountered: #{e.inspect}")
    log.error(e.backtrace.join("\n"))
  end

  def self.turn_on_database
    return log_skip_reason('db boot') if skip_shutdown?

    log.info('Starting to turn on database.')
    status = start_database
    log.info("New database status: #{status}")
  rescue StandardError => e
    log.error("Error encountered: #{e.inspect}")
    log.error(e.backtrace.join("\n"))
  end

  def self.turn_on_application
    return log_skip_reason('app boot') if skip_shutdown?

    log.info('Starting to bring app back from downtime.')
    remove_downtime_message
    log.info('Application brought back from downtime.')
  rescue StandardError => e
    log.error("Error encountered: #{e.inspect}")
    log.error(e.backtrace.join("\n"))
  end

  def self.show_downtime_message
    FileUtils.cp(
      Rails.public_path.join('application_unavailable.html'),
      maintenance_page_location
    )
  end

  def self.remove_downtime_message
    FileUtils.rm(maintenance_page_location)
  end

  def self.stop_database
    response = aws_client.stop_db_instance(
      db_instance_identifier: db_identifier
    )
    get_new_db_status(response)
  end

  def self.start_database
    response = aws_client.start_db_instance(
      db_instance_identifier: db_identifier
    )
    get_new_db_status(response)
  end

  def self.get_new_db_status(aws_response)
    aws_response.db_instance.db_instance_status
  end

  def self.log
    @log ||= Logger.new(Rails.root.join('log/downtime.log'))
  end

  def self.db_identifier
    host = Rails.configuration.database_configuration[Rails.env]['host']
    host.split('.').first
  end

  def self.aws_client
    Aws::RDS::Client.new(region: 'us-east-1')
  end

  def self.maintenance_page_location
    Rails.public_path.join('system/maintenance.html')
  end

  def self.log_skip_reason(process)
    log.info("Skipping #{process} until Oct 10, 2023.")
  end

  def self.skip_shutdown?
    full_uptime_end_date = Date.parse('1/10/2023')

    Rails.env.production? && (
      Date.today < full_uptime_end_date
    )
  end
end
