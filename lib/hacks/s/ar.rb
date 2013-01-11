HackTree.define do
  group :s do
    desc "Get `ActiveRecord::Base`"
    hack :ar do
      ActiveRecord::Base
    end
  end
end
