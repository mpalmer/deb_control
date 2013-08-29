require 'spec_helper'

describe DebControl::ControlFileBase do
  subject { DebControl::ControlFileBase }
  describe '#parse' do
    let(:single) do
      <<-EOF
Field1: b
Field2: c
      EOF
    end
    let(:multiple) do
      <<-EOF
Field1: c
Field3: b

Field6: 9
Field7: b
      EOF
    end
    let(:multiple_with_space) do
      <<-EOF
Field1: c
Field3: b
EOF + '  ' + <<-EOF
Field6: 9
Field7: b
      EOF
    end

    context 'paragraph splitting' do
      it 'parse paragraph' do
        expect(subject).to receive(:parse_paragraph).with(['Field1: b', 'Field2: c']).ordered
        expect(subject.parse(single).size).to eq 1
      end

      it 'parse multiple paragraphs separately' do
        expect(subject).to receive(:parse_paragraph).with(['Field1: c', 'Field3: b']).ordered
        expect(subject).to receive(:parse_paragraph).with(['Field6: 9', 'Field7: b']).ordered
        expect(subject.parse(multiple).size).to eq 2
      end

      it 'parse multiple paragraphs separated by line with spaces' do
        expect(subject).to receive(:parse_paragraph).with(['Field1: c', 'Field3: b']).ordered
        expect(subject).to receive(:parse_paragraph).with(['Field6: 9', 'Field7: b']).ordered
        expect(subject.parse(multiple).size).to eq 2
      end
    end

    context 'high level' do
      it 'parse paragraphs and fields' do
        parsed = subject.parse multiple
        expect(parsed.size).to eq 2
        expect(parsed[0]).to eq({'Field1' => 'c', 'Field3' => 'b'})
        expect(parsed[1]).to eq({'Field6' => '9', 'Field7' => 'b'})
      end
    end
  end

  describe '#parse_paragraph' do
    it 'single value without space' do
      expect(subject.parse_paragraph(['Field:value'])).to eq({ 'Field' => 'value' })
    end

    it 'single value' do
      expect(subject.parse_paragraph(['Field: value'])).to eq({ 'Field' => 'value' })
    end

    it 'single value with trailing space' do
      expect(subject.parse_paragraph(['Field: value  '])).to eq({ 'Field' => 'value' })
    end

    it 'value with colon' do
      expect(subject.parse_paragraph(['Field: v:alue'])).to eq({ 'Field' => 'v:alue' })
    end

    it 'two values' do
      values = subject.parse_paragraph(['Field: v:alue', 'Key: data'])
      expect(values).to eq({ 'Field' => 'v:alue', 'Key' => 'data' })
      expect(values.keys).to eq ['Field', 'Key']
    end

    it 'multi-line values' do
      values = subject.parse_paragraph(['Field: first-line', ' second-line'])
      expect(values).to eq({ 'Field' => "first-line\nsecond-line"})
    end
  end

  describe '#read' do
    let(:filename) { File.expand_path '../../fixtures/simple_control_file.txt', __FILE__ }

    it 'should parse the file' do
      parsed = subject.read filename
      expect(parsed).to be_instance_of subject
      expect(parsed.paragraphs.size).to eq 2
      expect(parsed.paragraphs.first['Field1']).to eq 'c'
    end
  end
end
