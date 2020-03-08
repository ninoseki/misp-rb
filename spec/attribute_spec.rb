# frozen_string_literal: true

RSpec.describe MISP::Attribute, :vcr do
  subject { described_class }

  let(:event) { MISP::Event.create(info: "test") }

  let(:attributes) {
    {
      value: "8.8.8.8",
      type: "ip-dst",
    }
  }

  describe ".create" do
    it do
      expect(subject.create(event.id, **attributes)).to be_a(described_class)
    end
  end

  describe ".search" do
    it do
      expect(subject.search(**attributes)).to be_an(Array)
    end
  end

  describe "#add_tag" do
    let(:tag_name) { "test tag" }
    let(:attribute) { subject.create(event.id, **attributes) }
    let(:tag) { MISP::Tag.create(name: tag_name) }

    it do
      expect(attribute.add_tag(tag)).to be_a(MISP::Tag)
    end
  end

  describe "#remove_tag" do
    let(:tag_name) { "test tag" }
    let(:attribute) { subject.create(event.id, **attributes) }
    let(:tag) { MISP::Tag.create(name: tag_name) }

    it do
      attribute.add_tag tag
      expect(attribute.remove_tag(tag)).to be_a(Hash)
    end
  end

  describe "#update" do
    let(:attribute) { subject.create(event.id, **attributes) }

    it do
      expect(attribute.update(value: "1.1.1.1")).to be_an(described_class)
    end
  end
end
