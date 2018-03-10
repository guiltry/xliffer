require 'nokogiri'

module XLIFFer
  class XLIFF
    class File
      attr_reader :source_language, :target_language, :original, :strings
      alias_method :file_name, :original
      def initialize(xml)
        unless XLIFF.xml_element?(xml) && file?(xml)
          fail ArgumentError, "can't create a File without a file subtree"
        end

        @xml = xml

        @original = @xml.attr('original')
        @source_language = @xml.attr('source-language')
        @target_language = @xml.attr('target-language')
        @strings = @xml.xpath('.//trans-unit').map { |tu| String.new(tu) }

        @tool = @xml.xpath('.//tool')
        if not @tool.empty?
          @tool_id = @tool.attr('tool-id').value
          @tool_name = @tool.attr('tool-name').value
          @tool_version = @tool.attr('tool-version').value
          @build_num = @tool.attr('build-num').value
        end
      end

      def [](id)
        @strings.find { |s| s.id == id }
      end

      def []=(id, target)
        self[id].target = target
      end

      def source_language=(val)
        @source_language = val
        @xml['source-language'] = val
      end

      def target_language=(val)
        @target_language = val
        @xml['target-language'] = val
      end

      def tool_id
        @tool_id
      end
      def tool_name
        @tool_name
      end
      def tool_version
        @tool_version
      end
      def build_num
        @build_num
      end

      private

      def file?(xml)
        xml.name.downcase == 'file'
      end
    end
  end
end
