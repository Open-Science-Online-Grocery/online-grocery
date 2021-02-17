class AddTooltipTextToConditionLabels < ActiveRecord::Migration[5.2]
  def change
    add_column :condition_labels, :tooltip_text, :string
  end
end
