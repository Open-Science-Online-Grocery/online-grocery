# frozen_string_literal: true

module Seeds
  module Development
    module Experiments
      def self.seed_experiments
        User.find_each do |user|
          return if user.experiments.any?

          3.times do
            Experiment.create!(
              user: user,
              name: Faker::Lorem.sentence
            )
          end
        end
      end
    end
  end
end
