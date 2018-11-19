SimpleCov.start 'rails' do
  add_filter 'app/jobs/application_job'
  add_filter '/vendor/'
  add_filter %r{lib\/scripts\/.*}
end
