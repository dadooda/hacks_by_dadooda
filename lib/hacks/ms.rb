# Optionally hook up CodeRay.
begin; require "coderay"; rescue LoadError; end

HackTree.define do
  desc <<-EOT
    Show method source

    Examples:

      c.ms Klass, :method_name
      c.ms Klass.method(:method_name)
      c.ms obj, :method_name
      c.ms obj.method(:method_name)

    Dependencies:

    - Gem `irb_hacks` >= 0.2.5 is required.
    - Gem `coderay`, if available, is automatically used for syntax highlighting.

    Sample `Gemfile`:

      gem "irb_hacks"
      gem "coderay"     # Neat Ruby colors!
  EOT
  hack :ms do |*args|
    if not Kernel.respond_to? :less
      puts "Error: `Kernel.less` is not available, install the `irb_hacks` gem"
      next
    end

    if args.empty?
      puts "Not enough arguments. See help for examples"
      next
    elsif (v = args[0]).respond_to? :source_location
      # Responds to `source_location`, the rest we don't care about. :)
      meth = v
    elsif args.size == 2
      receiver, method_name = *args
      meths = [:instance_method, :method].map do |q|
        if receiver.respond_to? q
          begin; receiver.send(q, method_name); rescue NameError; end
        end
      end.compact

      meth = meths[0] or begin
        puts "Undefined method: #{method_name}"
        next
      end
    else
      puts "Unknown invocation. See help for examples"
      next
    end

    file, line = *meth.source_location

    if not file
      puts "Method source not available".
      next
    end

    src = [
      "# Source of `#{file}`.",
      "",
      "",
    ].join("\n")

    skip_lines = src.lines.count

    src += File.read(file)
    src = CodeRay.scan(src, :ruby).terminal if defined? CodeRay

    Kernel.less src, :line => line + skip_lines
  end
end
