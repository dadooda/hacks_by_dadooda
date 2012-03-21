HackTree.define do
  group :rails do
    desc "Redirect ActiveRecord logs to Rails, don't log to console"
    hack :log_to_file do
      ActiveRecord::Base.logger = Rails.logger
      puts "ActiveRecord logging to console is disabled now"
    end
  end
end
