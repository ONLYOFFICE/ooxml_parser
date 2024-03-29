# frozen_string_literal: true

require 'spec_helper'

describe 'Conditional formatting rule types' do
  it 'CellIs has operator' do
    xlsx = OoxmlParser::Parser.parse('spec/workbook/worksheet/extensions/conditional_formattings/conditional_formatting_value_is.xlsx')
    expect(xlsx.worksheets.first.extension_list[0].conditional_formattings[0].rules[0].operator).to eq(:between)
  end

  it 'CellIs has formulas' do
    xlsx = OoxmlParser::Parser.parse('spec/workbook/worksheet/extensions/conditional_formattings/conditional_formatting_value_is.xlsx')
    expect(xlsx.worksheets.first.extension_list[0].conditional_formattings[0].rules[0].formulas[0].value).to eq('1')
    expect(xlsx.worksheets.first.extension_list[0].conditional_formattings[0].rules[0].formulas[1].value).to eq('5')
  end

  it 'Top10 has bottom' do
    xlsx = OoxmlParser::Parser.parse('spec/workbook/worksheet/extensions/conditional_formattings/conditional_formatting_top_10.xlsx')
    expect(xlsx.worksheets.first.extension_list[0].conditional_formattings[0].rules[0].bottom).to be_truthy
  end

  it 'Top10 has percent' do
    xlsx = OoxmlParser::Parser.parse('spec/workbook/worksheet/extensions/conditional_formattings/conditional_formatting_top_10.xlsx')
    expect(xlsx.worksheets.first.extension_list[0].conditional_formattings[0].rules[0].percent).to be_truthy
  end

  it 'Top10 has rank' do
    xlsx = OoxmlParser::Parser.parse('spec/workbook/worksheet/extensions/conditional_formattings/conditional_formatting_top_10.xlsx')
    expect(xlsx.worksheets.first.extension_list[0].conditional_formattings[0].rules[0].rank).to eq(10)
  end

  it 'Average has above_average' do
    xlsx = OoxmlParser::Parser.parse('spec/workbook/worksheet/extensions/conditional_formattings/conditional_formatting_average.xlsx')
    expect(xlsx.worksheets.first.extension_list[0].conditional_formattings[0].rules[0].above_average).to be_falsey
  end

  it 'Average has equal_average' do
    xlsx = OoxmlParser::Parser.parse('spec/workbook/worksheet/extensions/conditional_formattings/conditional_formatting_average.xlsx')
    expect(xlsx.worksheets.first.extension_list[0].conditional_formattings[0].rules[0].equal_average).to be_truthy
  end

  it 'Average has standard deviation' do
    xlsx = OoxmlParser::Parser.parse('spec/workbook/worksheet/extensions/conditional_formattings/conditional_formatting_average.xlsx')
    expect(xlsx.worksheets.first.extension_list[0].conditional_formattings[0].rules[0].standard_deviation).to eq(0)
  end

  it 'Text rule has text' do
    xlsx = OoxmlParser::Parser.parse('spec/workbook/worksheet/extensions/conditional_formattings/conditional_formatting_text.xlsx')
    expect(xlsx.worksheets.first.extension_list[0].conditional_formattings[0].rules[0].text).to eq('a')
  end

  it 'Date has time_period' do
    xlsx = OoxmlParser::Parser.parse('spec/workbook/worksheet/extensions/conditional_formattings/conditional_formatting_date.xlsx')
    expect(xlsx.worksheets.first.extension_list[0].conditional_formattings[0].rules[0].time_period).to eq(:last7Days)
  end

  it 'Stop if true' do
    xlsx = OoxmlParser::Parser.parse('spec/workbook/worksheet/extensions/conditional_formattings/conditional_formatting_stop_if_true.xlsx')
    expect(xlsx.worksheets.first.conditional_formattings[0].rules[0].stop_if_true).to be_truthy
  end
end
