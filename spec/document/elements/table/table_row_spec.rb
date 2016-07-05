require 'spec_helper'

describe OoxmlParser::TableRow do
  it 'table_row_height' do
    docx = OoxmlParser::DocxParser.parse_docx('spec/document/elements/table/row/table_row_height.docx')
    expect(docx.elements[1].rows[1].table_row_properties.height).to eq(1000)
  end

  it 'border_color_nil_1' do
    docx = OoxmlParser::DocxParser.parse_docx('spec/document/elements/table/row/border_color_nil_1.docx')
    expect(docx.elements.first.properties.table_borders.left).to be_nil
    expect(docx.elements.first.properties.table_borders.right).to be_nil
    expect(docx.elements.first.properties.table_borders.top).to be_nil
    expect(docx.elements.first.properties.table_borders.bottom).not_to be_nil
  end

  it 'border_color_nil_2' do
    docx = OoxmlParser::DocxParser.parse_docx('spec/document/elements/table/row/border_color_nil_2.docx')
    expect(docx.elements[29].properties.table_borders.left).to be_nil
    expect(docx.elements[29].properties.table_borders.right).to be_nil
    expect(docx.elements[29].properties.table_borders.top).to be_nil
    expect(docx.elements[29].properties.table_borders.bottom).to be_nil
  end

  it 'TableCellSpacing' do
    docx = OoxmlParser::DocxParser.parse_docx('spec/document/elements/table/row/row_cells_spacing.docx')
    docx.element_by_description(location: :canvas, type: :paragraph)[1].rows.each do |current_row|
      expect(current_row.cells_spacing.round(1)).to eq(1.5)
    end
  end
end
