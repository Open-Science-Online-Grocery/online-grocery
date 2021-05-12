# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

every :weekday, at: '8pm' do
  runner 'DowntimeSetter.turn_off_application'
  runner 'DowntimeSetter.turn_off_database'
end

# the database takes several minutes to start up, so we kick this off before
# turning the application back on.
every :weekday, at: '5:50am' do
  runner 'DowntimeSetter.turn_on_database'
end

every :weekday, at: '6am' do
  runner 'DowntimeSetter.turn_on_application'
end
