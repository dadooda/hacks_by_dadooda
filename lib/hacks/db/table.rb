HackTree.define do
  group :db do
    desc "List table in native format"
    hack :table do |table|
      if not table
        puts "USAGE: c.db.table <table>"
        next
      end

      begin
        conn = ActiveRecord::Base.connection
      rescue
        puts "Error: ActiveRecord not found"
        next
      end

      out = []

      res = begin
        conn.execute("SHOW CREATE TABLE #{table}")
      rescue StandardError => e
        puts "Database error: #{e.message}"
        next
      end

      out << res.to_a[0][1] << ""

      begin
        less out
      rescue
        puts "Error: `less` not found, install `irb_hacks` gem"
        next
      end
    end
  end
end
