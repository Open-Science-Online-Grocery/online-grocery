# frozen_string_literal: true

# represents an action a research participant takes during an experiment
class ParticipantAction < ApplicationRecord
  validates :session_identifier, presence: true

  belongs_to :condition, optional: true
end
