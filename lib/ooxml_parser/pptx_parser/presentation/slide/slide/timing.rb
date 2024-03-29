# frozen_string_literal: true

require_relative 'timing/time_node_list'
module OoxmlParser
  # Class for parsing `timing`
  class Timing < OOXMLDocumentObject
    attr_accessor :time_node_list, :build_list, :extension_list

    def initialize(parent: nil)
      @time_node_list = []
      @build_list = []
      @extension_list = []
      super
    end

    # Parse Timing object
    # @param node [Nokogiri::XML:Element] node to parse
    # @return [Timing] result of parsing
    def parse(node)
      node.xpath('*').each do |node_child|
        case node_child.name
        when 'tnLst'
          @time_node_list = TimeNodeList.new(parent: self).parse(node_child).elements
        end
      end
      self
    end
  end
end
