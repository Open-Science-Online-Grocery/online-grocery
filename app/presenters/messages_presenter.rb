# frozen_string_literal: true

# This presenter will render messages that come through as strings,
# arrays, or a hash with keys :header and :messages with values of type
# String and Array respectively.
#
# This class will aggregate messages passed via flash or @messages. It will
# collect messages with the same key from both flash and @messages so long as
# both are strings or both are arrays; other combinations are not supported.
class MessagesPresenter
  def initialize(flash, messages, template)
    @flash = flash
    @messages = (messages || {}).with_indifferent_access
    @template = template
  end

  def show_messages
    @template.content_tag(:div, data: { flash: true }, class: 'flash') do
      filtered_messages.flat_map do |key, values|
        values.select(&:present?).map do |value|
          @template.content_tag(:div, class: "ui message #{key}") do
            flash_html(value)
          end
        end
      end.reduce(:+)
    end
  end

  private def filtered_messages
    @filtered_messages ||= get_filtered_messages
  end

  private def get_filtered_messages
    all_messages = {}
    expected_keys.each do |key|
      values = [@flash[key], @messages[key]].compact
      all_messages[key] = values if values.any?
    end
    all_messages
  end

  private def flash_html(value)
    case value
    when Array
      render_list(value.flatten)
    when Hash
      render_hash(value)
    else
      value.to_s
    end
  end

  private def render_list(list)
    @template.content_tag(:ul) do
      list.map do |list_item|
        @template.content_tag(:li, list_item)
      end.reduce(:+)
    end
  end

  private def render_hash(hash)
    hash = hash.with_indifferent_access
    messages = hash[:messages]
    header = hash[:header]
    (
      @template.content_tag(:div, "#{header}:", class: 'header') +
      render_list([messages].flatten)
    )
  end

  # checking this before displaying because the Devise gem passes
  # unexpected flash keys that should not be displayed
  private def expected_keys
    %w(success alert notice info warning error)
  end
end
