class CreateProductTagsAndSubtags < ActiveRecord::Migration[5.2]
  def change
    create_table :tags do |t|
      t.string :name

      t.timestamps
    end

    create_table :subtags do |t|
      t.references :tag, index: true, null: false
      t.string :name

      t.timestamps
    end

    create_table :product_tags do |t|
      t.references :product, index: true, null: false
      t.references :tag, index: true, null: false
      t.references :subtag, index: true, null: true
      t.references :condition, index: true, null: true
      t.boolean :active, null: false, default: true

      t.timestamps
    end

    create_table :tag_csv_files do |t|
      t.string :csv_file
      t.references :condition, index: true, null: true

      t.timestamps
    end
  end
end
