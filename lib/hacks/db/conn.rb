HackTree.define do
  group :db do
    desc "Get `ActiveRecord::Base.connection`"
    hack :conn do
      # NOTE: Block result.
      begin
        ActiveRecord::Base.connection
      rescue
        puts "Error: ActiveRecord not found"
        false
      end
    end
  end
end
