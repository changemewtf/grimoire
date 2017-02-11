module Grimoire
  class BashStyle
    def initialize styles
      @attrs = {}

      styles.each do |style|
        case style.split(" ").first
        when "fg"
          @attrs[:fg] = style[2..-1]
        when "bg"
          @attrs[:bg] = style[2..-1]
        when "bold"
          @attrs[:bold] = true
        else
          raise "Unknown style start #{style.inspect}"
        end
      end
    end

    def wrap text
      "#{escapes}#{text}#{resets}"
    end

    def resets
      @attrs.inject "" do |str, (which, style)|
        if style.nil?
          str
        else
          str + reset(which)
        end
      end
    end

    def reset which
      {
        fg: "\e[39m",
        bg: "\e[49m",
        bold: "\e[22m" # 21 bold off rarely supported; 22 is neither bold nor faint
      }[which]
    end

    def escapes
      @attrs.inject "" do |str, (which, style)|
        if style.nil?
          str
        elsif which == :bold
          str + "\e[1m"
        else
          str + escape(which, style)
        end
      end
    end

    def escape which, style
      sys_colors = %w[black red green yellow blue magenta cyan white]

      chunks = style.split " "
      num = case chunks[0]
            when *sys_colors
              sys_colors.index chunks[0]
            when "light"
              sys_colors.index(chunks[1]) + 8
            when "gray"
              232 + chunks[1].to_i
            else
              # R G B from 0 to 5
              16 + (chunks[0].to_i * 36) + (chunks[1].to_i * 6) + chunks[2].to_i
            end

      {
        fg: "\e[38;5;#{num}m",
        bg: "\e[48;5;#{num}m"
      }[which]
    end
  end
end

Style = Grimoire::BashStyle
