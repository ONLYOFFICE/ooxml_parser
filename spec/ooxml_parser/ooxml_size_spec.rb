# frozen_string_literal: true

require 'spec_helper'

describe OoxmlParser::OoxmlSize do
  let(:size) { described_class.new(100_000, :dxa) }
  let(:size_cm) { described_class.new(1, :centimeter) }

  describe '#to_unit' do
    it 'OoxmlSize to other unit is same to base unit' do
      expect(size_cm.to_unit('foo')).to eq(size_cm.to_base_unit)
    end

    it 'OoxmlSize to one_240th_cm' do
      expect(size_cm.to_unit(:one_240th_cm))
        .to eq(described_class.new(240, :one_240th_cm))
    end
  end

  describe '#to_s' do
    it 'OoxmlSize to_s output is correct' do
      expect(size_cm.to_s).to eq('1.0 centimeter')
    end
  end

  it 'Twips and dxa units should be the same' do
    expect(described_class.new(100, :dxa)).to eq(described_class.new(100, :twip))
  end

  describe 'one_100th_point' do
    it '1 point converts to one_100th_point' do
      expect(described_class.new(1, :point).to_unit(:one_100th_point)).to eq(described_class.new(100, :one_100th_point))
    end
  end

  describe 'one_1000th_percent' do
    it 'compare same - percent and one_1000th_percent' do
      expect(described_class.new(44, :percent)).to eq(described_class.new(43_999, :one_1000th_percent))
    end

    it 'compare different - percent and one_1000th_percent' do
      expect(described_class.new(43, :percent)).not_to eq(described_class.new(43_999, :one_1000th_percent))
    end
  end

  describe 'pct' do
    it 'compare same - percent and one 50th of percent' do
      expect(described_class.new(44, :percent)).to eq(described_class.new(44 * 50, :pct))
    end

    it 'compare different - percent and one 50th of percent' do
      expect(described_class.new(43, :percent)).not_to eq(described_class.new(43.99 * 50, :pct))
    end
  end

  describe 'OoxmlSize#to_unit' do
    it 'to_unit to centimeters' do
      expect(size.to_unit(:centimeter)).to eq(described_class.new(176, :centimeter))
    end

    it 'to_unit to point' do
      expect(size.to_unit(:point)).to eq(described_class.new(5_000, :point))
    end

    it 'to_unit to half_point' do
      expect(size.to_unit(:half_point)).to eq(described_class.new(2_500, :half_point))
    end

    it 'to_unit to one_eighth_point' do
      expect(size.to_unit(:one_eighth_point)).to eq(described_class.new(625, :one_eighth_point))
    end

    it 'to_unit to one_100th_point' do
      expect(size.to_unit(:one_100th_point)).to eq(described_class.new(500_000, :one_100th_point))
    end

    it 'to_unit to dxa' do
      expect(size.to_unit(:dxa)).to eq(described_class.new(100_000, :dxa))
    end

    it 'to_unit to inch' do
      expect(size.to_unit(:inch)).to eq(described_class.new(69, :inch))
    end

    it 'to_unit to percent' do
      expect(size.to_unit(:percent)).to eq(described_class.new(1_270_000, :percent))
    end

    it 'to_unit to spacing_point' do
      expect(size.to_unit(:spacing_point)).to eq(described_class.new(50, :spacing_point))
    end
  end

  describe 'OoxmlSize#to_s' do
    it 'to_s return value in centimeters' do
      expect(size.to_s).to match(/176.*centimeter/)
    end
  end
end