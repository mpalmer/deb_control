module DebControl
  # Generic parser class for control files. It is design to be used as parent classes for specific
  # files like the debian source control file.
  #
  # @api public
  class ControlFileBase
    # @api public
    # @param [String] filecontent A string with all data that should be parsed
    # @return [Array<Hash<String, String>>] The parsed data: a array of paragraphs. Each paragraph
    #   is a Hash contain its field value pairs.
    def self.parse(filecontent)
      parsed = []
      current_paragraph = []
      filecontent.split("\n").each do |line|
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


    # @api private
    # @param [Array<String>] lines all lines of the paragraph
    # @return [Hash<String, String>] parsed key value pairs
    #
    def self.parse_paragraph(lines)
      fields = {}
      field = nil
      value = nil
      lines.each do |line|
        if line.include? ':'  # no value
          unless field.nil?
            fields[field] = value
          end
          field, value = line.split ':', 2
          value.strip!
        elsif line =~ /^\s/
          value += "\n" + line.strip
        else
          # error
        end
      end
      unless field.nil?
        fields[field] = value
      end
      fields
    end

    # Create a new ControlFileBase instances with the contain of the given file name.
    #
    # @api public
    # @param [String] filename A relative or absolute file name to the file that should be parsed.
    # @return [ControlFileBase] A new object instance contain the parsed data. Use the paragraphs
    #   accessor to use them.
    # @example
    #   control = ControlFileBase.read 'debian/control'
    #   puts control.paragraphs.first['Source']
    def self.read(filename)
      new parse File.read filename
    end

    def initialize(paragraphs)
      @paragraphs = paragraphs
    end

    attr_reader :paragraphs
  end
end
