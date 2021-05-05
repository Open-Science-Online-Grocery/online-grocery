# frozen_string_literal: true

# this service can "turn off" the application by:
#   1. showing an "application offline" message for any page request
#   2. turning off the RDS database (to save money)
# for #1, we leverage the infrastructure in place for `capistrano/maintenance`
# where the webserver (apache) has been configured to always show the file at
# `public/system/maintenance.html` instead of the application if that file
# exists.
class DowntimeSetter
  def self.log
    @log ||= Logger.new(Rails.root.join('log/downtime.log'))
  end

  def self.db_hostname
    Rails.configuration.database_configuration[Rails.env]['host']
  end

  def self.aws_client
    Aws::RDS::Client.new(region: 'us-east-1')
  end

  def self.turn_off_application
    log.info('Starting to put app into downtime.')
    FileUtils.cp(
      Rails.root.join('public/application_unavailable.html'),
      Rails.root.join('public/system/maintenance.html'),
    )
    response = aws_client.stop_db_instance(db_instance_identifier: db_hostname)
    log.info("Application put into downtime: #{response}")
  rescue => e
    log.error("Error encountered: #{e.inspect}")
    log.error(e.backtrace.join("\n"))
  end

  def self.turn_on_application
    log.info('Starting to bring app back from downtime.')
    FileUtils.rm(Rails.root.join('public/system/maintenance.html'))
    response = aws_client.stop_db_instance(db_instance_identifier: db_hostname)
    log.info("Application brought back from downtime: #{response}")
  rescue => e
    log.error("Error encountered: #{e.inspect}")
    log.error(e.backtrace.join("\n"))
  end
end
