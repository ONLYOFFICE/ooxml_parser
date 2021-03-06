# frozen_string_literal: true

module OoxmlParser
  # Character Alignment in XLSX
  class XlsxAlignment < OOXMLDocumentObject
    attr_accessor :horizontal, :vertical, :wrap_text, :text_rotation

    def initialize(params = {})
      @horizontal = params.fetch(:horizontal, :left)
      @vertical = params.fetch(:vertical, :bottom)
      @wrap_text = params.fetch(:wrap_text, false)
      super(parent: params[:parent])
    end

    # Parse XlsxAlignment object
    # @param node [Nokogiri::XML:Element] node to parse
    # @return [XlsxAlignment] result of parsing
    def parse(node)
      node.attributes.each do |key, value|
        case key
        when 'horizontal'
          @horizontal = value.value.to_sym
          @wrap_text = true if @horizontal == :justify
        when 'vertical'
          @vertical = value.value.to_sym
        when 'wrapText'
          @wrap_text = value.value.to_s == '1'
        when 'textRotation'
          @text_rotation = value.value.to_i
        end
      end
      self
    end
  end
end
