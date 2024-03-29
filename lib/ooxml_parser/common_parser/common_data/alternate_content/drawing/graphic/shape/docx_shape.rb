# frozen_string_literal: true

require_relative 'docx_shape/ooxml_text_box'
require_relative 'docx_shape/non_visual_shape_properties'
require_relative 'docx_shape/shape_style'
require_relative 'docx_shape/text_body'
require_relative 'shape_properties/docx_shape_properties'
require_relative 'shape_body_properties/ooxml_shape_body_properties'
module OoxmlParser
  # Class for parsing `sp`, `wsp` tags
  class DocxShape < OOXMLDocumentObject
    attr_accessor :non_visual_properties, :properties, :style, :body_properties, :text_body
    # @return [True, False] Specifies if text in shape is locked when sheet is protected
    attr_reader :locks_text

    alias shape_properties properties

    def initialize(parent: nil)
      @locks_text = true
      super
    end

    # @return [True, false] if structure contain any user data
    def with_data?
      return true if @text_body.nil?
      return true if @text_body.paragraphs.length > 1
      return true unless @text_body.paragraphs.first.runs.empty?
      return true if properties.preset_geometry

      false
    end

    # Parse DocxShape object
    # @param node [Nokogiri::XML:Element] node to parse
    # @return [DocxShape] result of parsing
    def parse(node)
      node.attributes.each do |key, value|
        case key
        when 'fLocksText'
          @locks_text = attribute_enabled?(value)
        end
      end

      node.xpath('*').each do |node_child|
        case node_child.name
        when 'nvSpPr'
          @non_visual_properties = NonVisualShapeProperties.new(parent: self).parse(node_child)
        when 'spPr'
          @properties = DocxShapeProperties.new(parent: self).parse(node_child)
        when 'style'
          @style = ShapeStyle.new(parent: self).parse(node_child)
        when 'txbx'
          @text_body = OOXMLTextBox.new(parent: self).parse(node_child)
        when 'txBody'
          @text_body = TextBody.new(parent: self).parse(node_child)
        when 'bodyPr'
          @body_properties = OOXMLShapeBodyProperties.new(parent: self).parse(node_child)
        end
      end
      self
    end
  end
end
