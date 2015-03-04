module Vedeu

  class HTMLRenderer

    # @param output [Array<Array<Vedeu::Char>>]
    # @return [String]
    def self.render(output)
      new(output).render
    end

    # @param output [Array<Array<Vedeu::Char>>]
    # @return [String]
    def self.to_file(output)
      new(output).to_file
    end

    # @param output [Array<Array<Vedeu::Char>>]
    # @return [Vedeu::HTMLRenderer]
    def initialize(output)
      @output = output
    end

    # @return [String]
    def render
      Template.parse(self, template)
    end

    # @param path [String]
    # @return [String]
    def to_file(path = file_path)
      content = render

      File.open(path, "w", 0644) { |file| file.write(content) }

      content
    end

    # @return [String]
    def html_body
      out = ''
      Array(output).each do |line|
        out << "<tr>\n"
        line.each do |char|
          out << char.to_html
          out << "\n"
        end
        out << "</tr>\n"
      end
      out
    end

    private

    attr_reader :output

    def template
      File.dirname(__FILE__) + '/templates/html_renderer.vedeu'
    end

    # @return [String]
    def file_path
      "/tmp/vedeu_html_#{timestamp}.html"
    end

    # return [Fixnum]
    def timestamp
      @timestamp ||= Time.now.to_i
    end

  end # HTMLRenderer

end # Vedeu