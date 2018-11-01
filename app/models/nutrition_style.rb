# frozen_string_literal: true

class NutritionStyle < ApplicationRecord
  store :rules, coder: JSON

  belongs_to :condition
end
