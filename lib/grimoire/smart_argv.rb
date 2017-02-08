module Grimoire
  class SmartArgv
    def initialize argv
      @argv = argv
    end

    def option key
      name = key.to_s
      char = name[0]
      short_option(char) || long_option(name)
    end

    def flag key
      name = key.to_s
      char = name[0]
      short_flag(char) || long_flag(name)
    end

    private

    def short_option char
      find_by_previous do |a|
        a.start_with?("-") && a.end_with?(char)
      end
    end

    def short_flag char
      got_flag? do |a|
        !a.start_with?("--") &&
          a.start_with?("-") &&
          a.include?(char)
      end
    end

    def long_option name
      find_by_previous do |a|
        a == "--#{name}"
      end
    end

    def long_flag name
      got_flag? do |a|
        a == "--#{name}"
      end
    end

    def find_by_previous &block
      find_with_offset 1, &block
    end

    def got_flag? &block
      !find_with_offset(0, &block).nil?
    end

    private

    def find_with_offset n
      @argv.each.with_index do |a, i|
        if yield a
          return @argv[i + n]
        end
      end
      nil
    end
  end
end

def ARGV.option key
  Grimoire::SmartArgv.new(ARGV).option key
end

def ARGV.flag key
  Grimoire::SmartArgv.new(ARGV).flag key
end
