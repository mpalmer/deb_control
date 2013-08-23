module DebControl
  class ControlFileBase
    def self.parse(file)
      parsed = []
      current_paragraph = []
      file.split("\n").each do |line|
        if line.strip == ''
          parsed << parse_paragraph(current_paragraph)
          current_paragraph = []
        else
          current_paragraph << line
        end
      end

      if current_paragraph.size > 0
        parsed << parse_paragraph(current_paragraph)
      end
      parsed
    end

    def self.parse_paragraph(lines)
      fields = {}
      lines.each do |line|
        field, value = line.split ':', 2
        fields[field] = value.strip
      end
      fields
    end

    def self.read(filename)
      new parse File.read filename
    end

    def initialize(paragraphs)
      @paragraphs = paragraphs
    end

    attr_reader :paragraphs
  end
end
