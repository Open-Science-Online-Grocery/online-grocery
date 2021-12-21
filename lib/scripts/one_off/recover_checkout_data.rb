# frozen_string_literal: true

require 'csv'

# to run from Rails console:
#   require_relative 'lib/scripts/one_off/recover_checkout_data'
#   RecoverCheckoutData.new.run
class RecoverCheckoutData
  include ActionView::Helpers::TranslationHelper

  def initialize(log_dir)
    @log_dir = log_dir
    @cart_settings_lines = []
    @in_process_requests = {}
    @ips_to_sids = Hash.new { |h, k| h[k] = [].to_set }
    @cart_settings_by_sid = {}
    @output_filepath = File.join(@log_dir, 'amended_chekcout_actions.csv')
  end

  def run
    parse_logs
    parse_cart_data
    write_action_csv
  end

  private def parse_logs
    Dir[File.join(@log_dir, '*')].sort.each do |filepath|
      File.foreach(filepath) do |line|
        if line.match(/\/api\/cart_settings\?condition_identifier=7ab074b4-0ec8-464c-bde4-d3bb100356a7/)
          # capture lines for POSTs to cart_settings endpoint; this is where
          # we'll get the cart product data
          @cart_settings_lines << line
        elsif line.match(/Started POST \"\/api\/participant_actions\"/)
          # correlate the rails request ID with the IP from this kind of line
          parse_post_line(line)
        elsif line.match(/Parameters/)
          # correlate the IP with the session_identifier (SID) from this kind
          # of line
          parse_params_line(line)
        end
      end
    end
    puts @ips_to_sids
  end

  private def parse_cart_data
    regex = /\/api\/cart_settings\?(?<params>\S+)" for (?<ip>\S+) at (?<timestamp>.+)/
    @cart_settings_lines.each do |line|
      match_data = line.match(regex)

      sids = @ips_to_sids[match_data[:ip]]
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
  end

  private def write_action_csv
    CSV.open(@output_filepath, 'wb') do |csv|
      csv << csv_headers
      @cart_settings_by_sid.each do |sid, data|
        next unless sid
        timestamp = localize(
          Time.zone.parse(data[:timestamp]),
          format: :with_seconds
        )
        data[:params].fetch('cart_products', {}).values.each do |product_attrs|
          product = Product.find(product_attrs['id'])
          csv << [
            'recommendation test',
            'training',
            sid,
            'checkout',
            product.name,
            product.id,
            product_attrs['quantity'],
            '',
            '',
            timestamp
          ]
        end
      end
    end
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
      @ips_to_sids[matching_ip].add(match_data[:sid].strip)
      @in_process_requests.delete(match_data[:request_id])
    end
  end

  private def csv_headers
    [
      'Experiment Name',
      'Condition Name',
      'Session Identifier',
      'Participant Action Type',
      'Product Name',
      'Product Id',
      'Quantity',
      'Serial Position',
      'Detail',
      'Participant Action Date/Time'
    ]
  end
end
