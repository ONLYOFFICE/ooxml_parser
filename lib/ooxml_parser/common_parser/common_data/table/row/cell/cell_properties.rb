# frozen_string_literal: true

require_relative 'grid_span'
module OoxmlParser
  # Class for parsing 'w:tcPr' element
  class CellProperties < OOXMLDocumentObject
    attr_accessor :fill, :color, :borders, :text_direction, :anchor, :table_cell_width, :borders_properties
    # @return [GridSpan] data about grid span
    attr_accessor :grid_span
    # @return [TableMargins] margins
    attr_accessor :vertical_merge
    # @return [ParagraphMargins] margins of text in cell
    attr_accessor :margins
    # @return [Shade] shade of cell
    attr_accessor :shade
    # @return [TableMargins] margins of cell
    attr_accessor :table_cell_margin
    # @return [True, False] This element will prevent text from
    # wrapping in the cell under certain conditions. If the cell width is fixed,
    # then noWrap specifies that the cell will not be smaller than that fixed
    # value when other cells in the row are not at their minimum. If the cell
    # width is set to auto or pct, then the content of the cell will not wrap.
    # > ECMA-376, 3rd Edition (June, 2011), Fundamentals and Markup Language Reference 17.4.30.
    attr_accessor :no_wrap
    # @return [ValuedChild] vertical align type
    attr_reader :vertical_align_object

    alias table_cell_borders borders_properties

    # Parse CellProperties object
    # @param node [Nokogiri::XML:Element] node to parse
    # @return [CellProperties] result of parsing
    def parse(node)
      @borders_properties = Borders.new
      @margins = ParagraphMargins.new(parent: self).parse(node)
      @color = PresentationFill.new(parent: self).parse(node)
      @borders = Borders.new(parent: self).parse(node)
      node.xpath('*').each do |node_child|
        case node_child.name
        when 'vMerge'
          @vertical_merge = ValuedChild.new(:symbol, parent: self).parse(node_child)
        when 'vAlign'
          @vertical_align_object = ValuedChild.new(:symbol, parent: self).parse(node_child)
        when 'gridSpan'
          @grid_span = GridSpan.new(parent: self).parse(node_child)
        when 'tcW'
          @table_cell_width = OoxmlSize.new.parse(node_child)
        when 'tcMar'
          @table_cell_margin = TableMargins.new(parent: self).parse(node_child)
        when 'textDirection'
          @text_direction_object = ValuedChild.new(:string, parent: self).parse(node_child)
          @text_direction = value_to_symbol(@text_direction_object)
        when 'noWrap'
          @no_wrap = option_enabled?(node_child)
        when 'shd'
          @shade = Shade.new(parent: self).parse(node_child)
        when 'fill'
          @fill = DocxColorScheme.new(parent: self).parse(node_child)
        when 'tcBdr'
          @borders_properties = Borders.new(parent: self).parse(node_child)
        when 'tcBorders'
          node_child.xpath('*').each do |border_child|
            case border_child.name
            when 'top'
              @borders_properties.top = BordersProperties.new(parent: self).parse(border_child)
            when 'right'
              @borders_properties.right = BordersProperties.new(parent: self).parse(border_child)
            when 'left'
              @borders_properties.left = BordersProperties.new(parent: self).parse(border_child)
            when 'bottom'
              @borders_properties.bottom = BordersProperties.new(parent: self).parse(border_child)
            when 'tl2br'
              @borders_properties.top_left_to_bottom_right = BordersProperties.new(parent: self).parse(border_child)
            when 'tr2bl'
              @borders_properties.top_right_to_bottom_left = BordersProperties.new(parent: self).parse(border_child)
            end
          end
        end
      end

      node.attributes.each do |key, value|
        case key
        when 'vert'
          @text_direction = value.value.to_sym
        when 'anchor'
          @anchor = value_to_symbol(value)
        end
      end
      self
    end

    # @return [nil, Symbol] vertical align of cell
    def vertical_align
      return nil unless @vertical_align_object

      @vertical_align_object.value
    end
  end
end
