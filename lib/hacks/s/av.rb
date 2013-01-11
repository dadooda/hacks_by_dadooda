HackTree.define do
  group :s do
    desc "Get `ActionView::Base`"
    hack :av do
      ActionView::Base
    end
  end
end
