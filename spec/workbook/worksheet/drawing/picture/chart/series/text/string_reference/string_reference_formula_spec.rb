# frozen_string_literal: true

require 'spec_helper'

describe 'My behaviour' do
  it 'formula.xlsx' do
    xlsx = OoxmlParser::XlsxParser.parse_xlsx('spec/workbook/worksheet/drawing/picture/chart/series/text/string_reference/formula/formula.xlsx')
    series = xlsx.worksheets[0].drawings[0].graphic_frame.graphic_data.first.series.first
    expect(series.text.reference.formula).to eq('Sheet1!D2')
  end
end
