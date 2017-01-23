class ::String
  def smart_deindent
    Grimoire::SmartDeindent.call self
  end
end

module Grimoire
  module SmartDeindent
    def self.call str
      first_line_indent = str.match(/^\s*/).to_s.size
      str.gsub /^\s{#{first_line_indent}}/, ''
    end
  end
end
