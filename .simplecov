# frozen_string_literal: true

SimpleCov.start 'rails' do
  add_filter 'app/jobs/application_job'
  add_filter '/vendor/'
  add_filter '/lib/scripts'
end
