# frozen_string_literal: true

class DowntimeSetter
  def self.turn_off_application
    FileUtils.cp(
      Rails.root.join('public/application_unavailable.html'),
      Rails.root.join('public/system/maintenance.html'),
    )
    # TODO: turn off db via rds api
  end

  def self.turn_on_application
    FileUtils.rm(Rails.root.join('public/system/maintenance.html'))
    # TODO: turn on db via rds api
  end
end
