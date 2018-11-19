# frozen_string_literal: true

module Seeds
  module Development
    module Conditions
      def self.seed_conditions
        Experiment.find_each do |experiment|
          next if experiment.conditions.any?

          (1..3).to_a.sample.times do
            Condition.create!(
              experiment: experiment,
              name: Faker::Lorem.sentence,
              uuid: SecureRandom.uuid,
              nutrition_styles: '{}',
              label_equation_tokens: '[]'
            )
          end
        end
      end
    end
  end
end
