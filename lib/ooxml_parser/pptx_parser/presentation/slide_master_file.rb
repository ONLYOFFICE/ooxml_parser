# frozen_string_literal: true

module OoxmlParser
  # Class for parsing SlideMaster files
  class SlideMasterFile < OOXMLDocumentObject
    # @return [CommonSlideData] common slide data
    attr_reader :common_slide_data

    # Parse SlideMaster
    # @param file [String] path to file to parse
    # @return [SlideMasterFile] result of parsing
    def parse(file)
      root_object.add_to_xmls_stack(file.gsub(root_object.unpacked_folder, ''))
      doc = parse_xml(file)
      doc.xpath('p:sldMaster/*').each do |node_child|
        case node_child.name
        when 'cSld'
          @common_slide_data = CommonSlideData.new(parent: self).parse(node_child)
        end
      end
      root_object.xmls_stack.pop
      self
    end
  end
end
