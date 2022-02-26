require './error'
require 'spec_helper'

RSpec.describe Error do
  let(:subject) { described_class }

  describe 'FileNotFound' do
    it 'can be raised an exception' do
      expect { raise subject::FileNotFound.new('File not found') }.to raise_error(StandardError, 'File not found')
    end
  end
end
