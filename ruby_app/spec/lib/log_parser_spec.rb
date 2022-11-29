# frozen_string_literal: true

require 'spec_helper'

describe LogParser do
  let(:file_path) { 'spec/fixtures/webserver.log' }

  context 'file does not exist' do
    let(:file_path) { 'wrong_file_path.log' }
    let(:expected_error) { 'File does not exist' }

    subject { described_class.new(file_path) }

    it 'raises an error' do
      expect { subject }.to raise_error(RuntimeError, expected_error)
    end
  end

  shared_examples 'produces expected output' do
    it { expect(subject).to eq(expected_output.strip) }
  end

  describe '#output_pages_ordered_by_most_views' do
    let(:expected_output) do
      <<~OUTPUT
        Page: /some_page Views: 3
        Page: /some_different_page Views: 2
        Page: /some_other_page/2 Views: 2
        Page: /some_other_page/1 Views: 1
        Page: /some_page/1 Views: 1
      OUTPUT
    end

    subject { described_class.new(file_path).output_pages_ordered_by_most_views }

    it_behaves_like 'produces expected output'
  end

  describe '#output_pages_ordered_by_most_unique_views' do
    let(:expected_output) do
      <<~OUTPUT
        Page: /some_other_page/2 Views: 2
        Page: /some_page Views: 2
        Page: /some_different_page Views: 1
        Page: /some_other_page/1 Views: 1
        Page: /some_page/1 Views: 1
      OUTPUT
    end

    subject { described_class.new(file_path).output_pages_ordered_by_most_unique_views }

    it_behaves_like 'produces expected output'
  end
end
