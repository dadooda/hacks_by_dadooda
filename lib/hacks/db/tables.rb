HackTree.define do
  group :db do
    desc <<-EOT
      List tables in native format

      Examples:

        >> c.db.tables
        >> c.db.tables /user/
        >> c.db.tables /^book/
    EOT

    hack :tables do |re = nil|
      begin
        conn = ActiveRecord::Base.connection
      rescue
        puts "Error: ActiveRecord not found"
        next
      end

      table_names = conn.tables

      if re
        table_names.select! {|table_name| table_name =~ re}
      end

      out = []

      table_names.sort.each do |table_name|
        # NOTE: MySQL is the only one available yet.
        res = conn.execute("SHOW CREATE TABLE #{table_name}")
        out << res.to_a[0][1] << ""
      end

      begin
        less out
      rescue
        puts "Error: `less` not found, install `irb_hacks` gem"
        next
      end

      table_names.size
    end
  end
end
