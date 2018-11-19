# frozen_string_literal: true

# a db view-backed model representing actions participants took by experiment
# and condition
class ExperimentResult < ApplicationRecord
  belongs_to :experiment
end
