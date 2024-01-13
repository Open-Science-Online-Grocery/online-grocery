# frozen_string_literal: true
ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  controller do
    skip_power_check
  end

  content do
    columns do
      column do
        panel 'Total API Token Requests', style: 'font-size: 24px; font-weight: bold;' do
          table_for [['Pending', ApiTokenRequest.pending.count],
                      ['Approved', ApiTokenRequest.approved.count],
                      ['Rejected', ApiTokenRequest.rejected.count]] do
            column 'Status' do |row|
              row[0]
            end
            column 'Count' do |row|
              span style: 'font-size: 24px; font-weight: bold;' do
                row[1]
              end
            end
          end
        end
      end

      column do
        panel 'Total Users', style: 'font-size: 24px; font-weight: bold;' do
          para "#{User.count}"
        end
      end
    end
  end
end
