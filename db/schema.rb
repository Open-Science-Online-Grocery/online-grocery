# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_11_12_183838) do

  create_table "cart_summary_labels", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "image"
    t.boolean "built_in", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "condition_cart_summary_labels", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "condition_id"
    t.bigint "cart_summary_label_id"
    t.text "label_equation_tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cart_summary_label_id"], name: "index_condition_cart_summary_labels_on_cart_summary_label_id"
    t.index ["condition_id"], name: "index_condition_cart_summary_labels_on_condition_id"
  end

  create_table "condition_product_sort_fields", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "condition_id"
    t.bigint "product_sort_field_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["condition_id"], name: "index_condition_product_sort_fields_on_condition_id"
    t.index ["product_sort_field_id"], name: "index_condition_product_sort_fields_on_product_sort_field_id"
  end

  create_table "conditions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "experiment_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "uuid", null: false
    t.text "nutrition_styles"
    t.bigint "label_id"
    t.string "label_position"
    t.integer "label_size"
    t.text "label_equation_tokens"
    t.bigint "default_sort_field_id"
    t.string "default_sort_order"
    t.text "sort_equation_tokens"
    t.boolean "show_price_total", default: false, null: false
    t.string "food_count_format"
    t.boolean "filter_by_custom_categories", default: false, null: false
    t.index ["default_sort_field_id"], name: "index_conditions_on_default_sort_field_id"
    t.index ["experiment_id"], name: "index_conditions_on_experiment_id"
    t.index ["label_id"], name: "index_conditions_on_label_id"
  end

  create_table "experiments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_experiments_on_user_id"
  end

  create_table "labels", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.boolean "built_in", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image"
  end

  create_table "participant_actions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "session_identifier"
    t.bigint "condition_id"
    t.string "action_type"
    t.string "product_name"
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["condition_id"], name: "index_participant_actions_on_condition_id"
  end

  create_table "product_sort_fields", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "product_tags", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "tag_id", null: false
    t.bigint "subtag_id"
    t.bigint "condition_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["condition_id"], name: "index_product_tags_on_condition_id"
    t.index ["product_id"], name: "index_product_tags_on_product_id"
    t.index ["subtag_id"], name: "index_product_tags_on_subtag_id"
    t.index ["tag_id"], name: "index_product_tags_on_tag_id"
  end

  create_table "products", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "size"
    t.text "description"
    t.string "image_src"
    t.string "serving_size"
    t.string "servings"
    t.integer "calories_from_fat"
    t.integer "calories"
    t.integer "total_fat"
    t.integer "saturated_fat"
    t.integer "trans_fat"
    t.integer "poly_fat"
    t.integer "mono_fat"
    t.decimal "cholesterol", precision: 6, scale: 2
    t.integer "sodium"
    t.integer "potassium"
    t.integer "carbs"
    t.integer "fiber"
    t.integer "sugar"
    t.integer "protein"
    t.text "vitamins"
    t.text "ingredients"
    t.text "allergens"
    t.decimal "price", precision: 64, scale: 12
    t.integer "category_id"
    t.integer "subcategory_id"
    t.integer "starpoints"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subcategories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "category_id"
    t.integer "display_order"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subtags", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "tag_id", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_subtags_on_tag_id"
  end

  create_table "tag_csv_files", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "csv_file"
    t.bigint "condition_id"
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["condition_id"], name: "index_tag_csv_files_on_condition_id"
  end

  create_table "tags", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
