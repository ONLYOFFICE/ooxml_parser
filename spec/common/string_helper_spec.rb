# frozen_string_literal: true

require 'spec_helper'

describe OoxmlParser::StringHelper do
  describe 'StringHelper.complex?' do
    it 'StringHelper.complex? check true' do
      expect(OoxmlParser::StringHelper).to be_complex('3+5i')
    end

    it 'StringHelper.complex? check false' do
      expect(OoxmlParser::StringHelper).not_to be_complex('a+5i')
    end
  end
end
