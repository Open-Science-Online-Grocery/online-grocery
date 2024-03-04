# frozen_string_literal: true

# :no doc:
class AddPopupMessageEnabledToTempCarts < ActiveRecord::Migration[6.1]
  def change
    rename_column :temp_carts, :pop_up_message, :popup_message
    add_column :temp_carts, :popup_message_enabled, :boolean, default: true
  end
end
