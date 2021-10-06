# frozen_string_literal: true

class CustomSorting < ApplicationRecord
  belongs_to :condition
  belongs_to :product

  scope :for_session_identifier, ->(session_identifier) do
    where(session_identifier: session_identifier)
  end
end
