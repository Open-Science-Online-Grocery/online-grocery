# frozen_string_literal: true

# Represents temporary cart saved in db to populate that when a
# user visits the site
class TempCart < ApplicationRecord
  validates :session_id, presence: true, uniqueness: true
  has_many :cart_items, dependent: :destroy

  accepts_nested_attributes_for :cart_items
end
