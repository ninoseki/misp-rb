# frozen_string_literal: true

RSpec.describe MISP::Event, :vcr do
  let(:attributes) {
    {
      Event: {
        info: "teast"
      }
    }
  }

  include_examples "create example"
  include_examples "delete example"
  include_examples "get example"
  include_examples "update example"
  include_examples "list example"

  describe "#to_h" do
    let(:event) { subject.new attributes }

    it do
      expect(event.to_h).to be_a(Hash)
    end
  end

  describe ".search" do
    it do
      expect(subject.search(attributes)).to be_an(Array)
    end
  end

  describe "#add_attribute" do
    let(:event) { subject.create **attributes }
    let(:attribute) {
      MISP::Attribute.new(value: "8.8.8.8", type: "ip-dst")
    }

    it do
      expect(event.add_attribute(attribute)).to be_a(described_class)
    end
  end

  describe "#add_tag" do
    let(:event) { subject.create attributes }
    let(:tag) {
      MISP::Tag.new(name: "test")
    }

    it do
      expect(event.add_tag(tag)).to be_a(described_class)
    end
  end
end
