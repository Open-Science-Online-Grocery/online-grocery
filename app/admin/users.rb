# frozen_string_literal: true

ActiveAdmin.register(User) do
  controller do
    skip_power_check
  end
end
