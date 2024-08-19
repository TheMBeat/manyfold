require "rails_helper"

RSpec.describe ProcessUploadedFileJob do
  context "when detecting hidden files" do
    it "detects normal files" do
      expect(described_class.new.send(:hidden?, "test.stl")).to be false
    end

    it "detects normal files in subfolders" do
      expect(described_class.new.send(:hidden?, "test/test.stl")).to be false
    end

    it "detects hidden files" do
      expect(described_class.new.send(:hidden?, ".test.stl")).to be true
    end

    it "detects hidden files in subfolders" do
      expect(described_class.new.send(:hidden?, "test/.test.stl")).to be true
    end

    it "detects normal files in hidden subfolders" do
      expect(described_class.new.send(:hidden?, ".test/test.stl")).to be true
    end
  end

  context "when counting common path prefixes" do
    it "returns zero if there are no directories at all" do
      expect(described_class.new.send(:count_common_elements, [])).to eq 0
    end

    it "returns zero if there are no common prefixes" do
      expect(described_class.new.send(:count_common_elements, [
        ["folder1"],
        ["folder2"],
        []
      ])).to eq 0
    end

    it "returns the number of common prefixes if present" do
      expect(described_class.new.send(:count_common_elements, [
        ["root", "sub", "folder1"],
        ["root", "sub", "folder2"]
      ])).to eq 2
    end

    it "returns zero for *some* common prefixes but not on everything" do
      expect(described_class.new.send(:count_common_elements, [
        ["folder1", "sub1"],
        ["folder1", "sub2"],
        ["folder2", "sub1"]
      ])).to eq 0
    end
  end

  context "when errors occur during processing" do
    let(:library) { create(:library) }
    let(:file) { Rack::Test::UploadedFile.new(StringIO.new, original_filename: "test.zip") }

    it "removes the created model" do # rubocop:todo RSpec/ExampleLength
      job = described_class.new
      allow(job).to receive(:unzip).and_raise(StandardError)
      expect {
        begin
          job.perform(library.id, file)
        rescue
          nil
        end
      }.not_to change(Model, :count)
    end

    it "leaves the uploaded file in place"
  end
end
