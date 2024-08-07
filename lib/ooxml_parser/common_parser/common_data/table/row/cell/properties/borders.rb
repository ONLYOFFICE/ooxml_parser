# frozen_string_literal: true

require_relative 'border'
module OoxmlParser
  # Borders data
  class Borders < ParagraphBorders
    attr_accessor :left, :right, :top, :bottom, :inner_vertical, :inner_horizontal, :display, :between, :bar,
                  :top_left_to_bottom_right, :top_right_to_bottom_left, :offset_from

    def initialize(parent: nil)
      @left = BordersProperties.new
      @right = BordersProperties.new
      @top = BordersProperties.new
      @bottom = BordersProperties.new
      @between = BordersProperties.new
      @inner_horizontal = BordersProperties.new
      @inner_vertical = BordersProperties.new
      super
    end

    # Method to copy object
    # @return [Borders] copied object
    def copy
      new_borders = Borders.new
      new_borders.left = @left if @left
      new_borders.right = @right if @right
      new_borders.top = @top if @top
      new_borders.bottom = @bottom if @bottom
      new_borders.inner_vertical = @inner_vertical if @inner_vertical
      new_borders.inner_horizontal = @inner_horizontal if @inner_horizontal
      new_borders.between = @between if @between
      new_borders.display = @display if @display
      new_borders.bar = @bar if @bar
      new_borders
    end

    # Compare this object to other
    # @param other [Object] any other object
    # @return [True, False] result of comparision
    def ==(other)
      @left == other.left && @right == other.right && @top == other.top && @bottom == other.bottom if other.is_a?(Borders)
    end

    def each_border
      yield(bottom)
      yield(inner_horizontal)
      yield(inner_vertical)
      yield(left)
      yield(right)
      yield(top)
    end

    def each_side
      yield(bottom)
      yield(left)
      yield(right)
      yield(top)
    end

    # @return [String] result of convert of object to string
    def to_s
      "Left border: #{left}, Right: #{right}, Top: #{top}, Bottom: #{bottom}"
    end

    def visible?
      visible = false
      each_side do |current_size|
        visible ||= current_size.visible?
      end
      visible
    end

    # Parse Borders object
    # @param node [Nokogiri::XML:Element] node to parse
    # @return [Borders] result of parsing
    def parse(node)
      node.xpath('*').each do |node_child|
        case node_child.name
        when 'lnL', 'left'
          @left = TableCellLine.new(parent: self).parse(node_child)
        when 'lnR', 'right'
          @right = TableCellLine.new(parent: self).parse(node_child)
        when 'lnT', 'top'
          @top = TableCellLine.new(parent: self).parse(node_child)
        when 'lnB', 'bottom'
          @bottom = TableCellLine.new(parent: self).parse(node_child)
        when 'insideV'
          @inner_vertical = TableCellLine.new(parent: self).parse(node_child)
        when 'insideH'
          @inner_horizontal = TableCellLine.new(parent: self).parse(node_child)
        end
      end
      self
    end
  end
end
