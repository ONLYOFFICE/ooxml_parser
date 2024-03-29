# frozen_string_literal: true

module OoxmlParser
  # Helper methods for parsing default style
  module DefaultStyleHelper
    # Parse default style
    # @return [void]
    def parse_default_style
      parse_default_style_paragraph_properties
      parse_default_style_run_properties
      parse_default_character_style
      root_object.default_table_paragraph_style = root_object.default_paragraph_style.dup
      root_object.default_table_paragraph_style.spacing = Spacing.new(0, 0, 1, :auto)
      root_object.default_table_run_style = root_object.default_run_style.dup
      parse_default_table_style
    end

    # Perform parsing styles.xml
    def parse_styles
      file = "#{root_object.unpacked_folder}/word/styles.xml"
      root_object.default_paragraph_style = DocxParagraph.new(parent: self)
      root_object.default_table_paragraph_style = DocxParagraph.new(parent: self)
      root_object.default_run_style = DocxParagraphRun.new(parent: self)
      root_object.default_table_run_style = DocxParagraphRun.new(parent: self)

      return unless File.exist?(file)

      @styles = Styles.new(parent: self).parse
      @numbering = Numbering.new(parent: self).parse

      if @styles&.document_defaults&.paragraph_properties_default
        root_object.default_paragraph_style = DocxParagraph.new(parent: self)
                                                           .parse(@styles.document_defaults
                                                                         .paragraph_properties_default
                                                                         .raw_node, 0)
      end
      if @styles&.document_defaults&.run_properties_default&.run_properties
        root_object.default_run_style = DocxParagraphRun.new(parent: self)
                                                        .parse_properties(@styles
                                                                            .document_defaults
                                                                            .run_properties_default
                                                                            .run_properties
                                                                            .raw_node)
      end
      parse_default_style
    end

    private

    def parse_default_style_paragraph_properties
      return unless @styles&.default_style(:paragraph)&.paragraph_properties_node

      DocxParagraph.new(parent: self).parse_paragraph_style(@styles.default_style(:paragraph)
                                                                   .paragraph_properties_node,
                                                            root_object.default_run_style)
    end

    def parse_default_style_run_properties
      return unless @styles&.default_style(:paragraph)&.run_properties_node

      root_object.default_run_style
                 .parse_properties(@styles.default_style(:paragraph)
                                                .run_properties_node)
    end

    # Parse default character style
    def parse_default_character_style
      return unless @styles&.default_style(:character)&.run_properties_node

      root_object.default_run_style
                 .parse_properties(@styles.default_style(:character)
                                                .run_properties_node)
    end

    # Parse default table style
    def parse_default_table_style
      return unless @styles&.default_style(:table)&.run_properties_node

      root_object.default_table_run_style
                 .parse_properties(@styles.default_style(:table)
                                          .run_properties_node)
    end
  end
end
