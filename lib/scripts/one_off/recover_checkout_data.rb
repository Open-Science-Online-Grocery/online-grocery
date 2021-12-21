# to run from Rails console:
#   require_relative 'lib/scripts/one_off/recover_checkout_data'
#   RecoverCheckoutData.new.run

class RecoverCheckoutData
  def initialize(log_dir)
    @log_dir = log_dir
    @cart_settings_log_filepath = File.join(@log_dir, 'cart_settings.log')
    @output_filepath = File.join(@log_dir, 'amended_chekcout_actions.csv')
    @ip_to_sid = Hash.new { |h, k| h[k] = [].to_set }
    @in_process_requests = {}
    @cart_settings_by_sid = {}
  end

  def run
    # create_cart_settings_log
    match_ips_to_sids
    parse_cart_data

    regex = /\/api\/cart_settings\?(?<params>\S+)" for (?<ip>\S+) at (?<timestamp>.+)/
    File.foreach(@cart_settings_log_filepath) do |line|
      match_data = line.match(regex)

      sids = @ip_to_sid[match_data[:ip]]
      if sids.many?
        puts "Too many sids for #{match_data[:ip]}: #{sids}"
        next
      end

      # intentionally overwriting any older data, since we want to capture the
      # last params submitted to cart_settings, as this captures the cart at
      # checkout.
      @cart_settings_by_sid[sids.first] = {
        params: Rack::Utils.parse_nested_query(match_data[:params]),
        timestamp: match_data[:timestamp]
      }
    end
    binding.pry
  end

  # create a single file of all the log lines where requests were made to the
  # cart_settings endpoint; this is where the data about cart products at
  # checkout is.
  private def create_cart_settings_log
    FileUtils.rm(@cart_settings_log_filepath)
    Dir[File.join(@log_dir, '*')].each do |filepath|
      `grep cart_settings #{filepath} >> #{@cart_settings_log_filepath}`
    end
  end

  def match_ips_to_sids
    Dir[File.join(@log_dir, '*')].each do |filepath|
      File.foreach(filepath) do |line|
        if line.match(/Started POST \"\/api\/participant_actions\"/)
          parse_post_line(line)
        elsif line.match(/Parameters/)
          parse_params_line(line)
        end
      end
    end
    puts @ip_to_sid
  end

  private def parse_post_line(line)
    regex = /(?<request_id>\[\S+\]) Started POST \"\/api\/participant_actions\" for (?<ip>\S+)/
    match_data = line.match(regex)
    @in_process_requests[match_data[:request_id]] = match_data[:ip]
  end

  private def parse_params_line(line)
    return unless line.match(/\"condition_identifier\"=>\"7ab074b4-0ec8-464c-bde4-d3bb100356a7\"/)
    regex = /(?<request_id>\[\S+\])\s+Parameters:.+\"session_id\"=>\"(?<sid>[^\"]+)\",/
    match_data = line.match(regex)
    return unless match_data
    matching_ip = @in_process_requests[match_data[:request_id]]
    if matching_ip
      @ip_to_sid[matching_ip].add(match_data[:sid].strip)
      @in_process_requests.delete(match_data[:request_id])
    end
  end
end
