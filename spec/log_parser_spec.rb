require './lib/log_parser'
require 'spec_helper'

RSpec.describe LogParser do
  let(:file_path) { './spec/data/webserver.log' }
  let(:subject) { described_class.new(file_path) }
  let(:parsed_views) do
    {
      '/help_page/1' => [
        '126.318.035.038',
        '929.398.951.889',
        '722.247.931.582',
        '646.865.545.408'
      ],
      '/contact' => [
        '184.123.665.067',
        '184.123.665.067'
      ],
      '/home' => [
        '184.123.665.067',
        '235.313.352.950',
        '235.313.352.950',
        '235.313.352.950'
      ],
      '/about/2' => [
        '444.701.448.104',
        '444.701.448.104'
      ],
      '/index' => [
        '444.701.448.104',
        '444.701.448.104'
      ],
      '/about' => [
        '061.945.150.735'
      ]
    }
  end

  describe '#initialize' do
    it 'loads the log file' do
      expect(subject.file_path).to eq(file_path)
    end

    it 'sets visits to empty hash' do
      expect(subject.visits).to eq({})
    end
  end

  describe '#webparse' do
    it 'opens the file and reads line by line' do
      subject.webparse
      expect(subject.visits).to eq(parsed_views)
    end
  end

  describe '#list_most_page_views' do
    let(:printed) do
      "/home 4 visits\n/help_page/1 4 visits\n/index 2 visits\n/about/2 2 visits\n/contact 2 visits\n/about 1 visits\n"
    end

    it 'returns a descending list of page views' do
      subject.instance_variable_set(:@visits, parsed_views)
      expect { subject.list_most_page_views }.to output(printed).to_stdout
    end
  end

  describe '#list_unique_views' do
    let(:printed) do
      "/help_page/1 4 unique views\n/home 2 unique views\n/about 1 unique views\n/index 1 unique views\n/about/2 1 unique views\n/contact 1 unique views\n"
    end

    it 'returns a descending list of unique page views' do
      subject.instance_variable_set(:@visits, parsed_views)
      expect { subject.list_unique_views }.to output(printed).to_stdout
    end
  end

  describe '#file_exists?' do
    it 'raises exception when file does not exist' do
      expect { subject.send(:file_exists?, '') }
      .to raise_error(Error::FileNotFound, 'File does not exist')
    end

    it 'returns file path if file exists' do
      expect(subject.send(:file_exists?, file_path)).to eq(file_path)
    end
  end

  describe '#descending' do
    let(:unordered_hash) { { a: 2, b: 3, c: 1 } }
    let(:ordered_hash) { [{ b: 3 }, { a: 2 }, { c: 1 }] }

    it 'sorts by hash value and orders by descending, returning an array' do
      expect(subject.send(:descending, unordered_hash)).to eq(ordered_hash)
    end
  end

  describe '#page_views' do
    let(:page_views) do
      [
        { '/home' => 4 },
        { '/help_page/1' => 4 },
        { '/index' => 2 },
        { '/about/2' => 2 },
        { '/contact' => 2 },
        { '/about' => 1 }
      ]
    end

    it 'returns a descending list of page views' do
      subject.instance_variable_set(:@visits, parsed_views)
      expect(subject.send(:page_views)).to eq(page_views)
    end
  end

  describe '#unique_views' do
    let(:unique_views) do
      [
        { '/help_page/1' => 4 },
        { '/home' => 2 },
        { '/about' => 1 },
        { '/index' => 1 },
        { '/about/2' => 1 },
        { '/contact' => 1 }
      ]
    end

    it 'returns a descending list of unique page views' do
      subject.instance_variable_set(:@visits, parsed_views)
      expect(subject.send(:unique_views)).to eq(unique_views)
    end
  end

  describe '#print_views' do
    let(:views) do
      [
        { '/home' => 4 },
        { '/help_page/1' => 4 },
        { '/about' => 1 }
      ]
    end

    let(:printed) do
      "/home 4 visits\n/help_page/1 4 visits\n/about 1 visits\n"
    end

    it 'prints the page visits with type to stdout' do
      expect { subject.send(:print_views, views, 'visits') }.to output(printed).to_stdout
    end
  end
end
