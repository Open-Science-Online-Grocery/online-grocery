# frozen_string_literal: true

class CreateCartSummaryLabels < ActiveRecord::Migration[5.2]
  def change
    create_table :cart_summary_labels do |t|
      t.string :name
      t.string :image
      t.boolean :built_in, default: false

      t.timestamps
    end

    create_table :condition_cart_summary_labels do |t|
      t.references :condition
      t.references :cart_summary_label
      t.text :label_equation_tokens

      t.timestamps
    end
  end
end
