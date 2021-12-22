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
        next unless sid && sid.in?(target_sids)

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

  private def target_sids
    %w[
      A10STLCK650JHQ
      A11LL3J3YSXB4U
      A11S8IAAVDXCUS
      A125WQFXL6A3KA
      A12IHTKQFQIPD1
      A14YQGOZX4KRMA
      A171UXH8M8F6HS
      A1721FMJBGZVYE
      A19OCD2Q0K2U6M
      A19WXS1CLVLEEX
      A1AZGP16G9TURZ
      A1BKYMEF2K879Y
      A1CB72B51L7TKE
      A1CY7IOJ9YH136
      A1EHEQSM7S7PLO
      A1H5Q9HRH4RPZU
      A1I34C8RHIDMUI
      A1I7H6RDJS4EKN
      A1J4TXVBRW33KN
      A1JTU2MO4GO807
      A1JVZ2MVPSFZA
      A1KHZG8LZQ25RF
      A1KZ0KE93WNN5O
      A1LK4T9P64HPV6
      A1N81DHJ97L8OL
      A1PBFDQR599N3K
      A1PLQGQ95NICAF
      A1R1E7TZ9OHFIG
      A1S1K7134S2VUC
      A1SYMCOR29IWNA
      A1T0ND039EWAVV
      A1T3ROSW2LC4FG
      A1TJ3TVCUUOYU3
      A1TNICCDSHTUXS
      A1WIFU6K17Q9VZ
      A1WPGNK8Y65BV3
      A1Y7SUOJIVLR4E
      A1YPIJR0B4YDEW
      A20X6V1AAXZGNZ
      A23BWWRR7J5XLS
      A23EGLIF8IEH11
      A247BLFS76OCMO
      A26K8OELA8ZDI9
      A27TE0L5XP1H0U
      A2AAFWAAS9C1QC
      A2BGRGVU9HG0C6
      A2CPI18KZN30KW
      A2DLYBXZNSSJ4S
      A2EED3HLTA96CP
      A2FP41BSPG0Y4A
      A2FRD8U3DU923Q
      A2HFVL6GHX9R9V
      A2IEWBVCH5DAKB
      A2IZAD6SRVCPRY
      A2ND52KJ1AIYEK
      A2NQSULUMCZIKT
      A2NVO55DO76R80
      A2OZKKX2O0YTLD
      A2Q0D3TOREOIQ8
      A2RBVMD2HTBCZ9
      A2TXC8Q2IFGRXH
      A2YG71R13G0CYR
      A2Z9N8TQQGZI38
      A2ZJV0WON2390H
      A31WYNBU4IJPSV
      A33921T4I2XIRS
      A33S6Y64WIA1T6
      A33Z6BHAJUGCHY
      A34EHWOYRBL6OZ
      A35OWV8U5NMY15
      A35VA8NSI67Q8
      A36HFMF9Z4BGS8
      A3785TR8D5I81Q
      A387QR9H4L2IHO
      A397HP5TSIF2LO
      A3BLJ6QSDTZC9U
      A3BU8UL4W258UU
      A3CFJ4DCGG7BF5
      A3CMWYLWMENHLZ
      A3DDTGMRDXR9NR
      A3DKLZQ9T353MH
      A3DUPRZSMU9W5R
      A3DZVN0RJGJ8XM
      A3E50NZCJNLDG1
      A3EHDY67QENKPT
      A3F2W4HZRDKNW7
      A3F51C49T9A34D
      A3G3TIX6FEMN8R
      A3GW3MPLVGG7PZ
      A3H2ZK3SPCGXD9
      A3I5ZQI3WP7NS4
      A3JZS32RQUWGJM
      A3K1P4SPR8XS7R
      A3K2VSBTT3WUTI
      A3KHOW5FW32RUL
      A3MVVJHNQESGP4
      A3O6BQM1FNAEAQ
      A3PZFJZ8Q17O33
      A3QJJR5Y3XE92N
      A3QRZPJT2CT2IK
      A3QUGOFKETG4M
      A3R8KKND7IBAZN
      A3RCX3IQ8L6HHW
      A3RHJEMZ4EGY2U
      A3TON7FVDBDG35
      A40O6S62MI2VC
      A4OTKOPHDLW3T
      A55V2U9UG3Z47
      A5CIHEPULDFUF
      AB8BRFF4ZTZ40
      ABMPX2Y2IRBMG
      ACJ6NSCIWMUZI
      AD1ILDUXZHASF
      AD75IYA9OIIQF
      AFFXVHHBUWW4D
      AFRKVRPZ2RHY8
      AGWSOBI4I4T9Z
      AGZ0KJNGENZ1J
      AIEKCWYZTS41V
      AJQGWGESKQT4Y
      AMHUDJ44HF1ZH
      ANYB94DHDJKNO
      AP9M4LGBH8FYM
      APAR2A1F4RB0N
      APGX2WZ59OWDN
      APRZ7BR8C0ZMQ
      AQ53YJDPDDLZ
      AQKC1VIZAZ6VI
      AQMPJO4O175ZQ
      AQNZORQPWVOKO
      AQOXSP4W3ITSW
      AS2WTWYVRW9BV
      ASCBKU2SM61JU
      ASF5V3K4IFP4K
      AT79ID7O6DI9O
      AU5FXW94DCPK9
      AXG2QCW21F3S7
      AY6EYIDUN6SI1
      AZNIEFUIVB2H0
    ]
  end
end
