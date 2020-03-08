# frozen_string_literal: true

RSpec.describe MISP::Org do
  subject { described_class.new **attributes }

  let(:id) { 1 }
  let(:name) { "test" }

  let(:attributes) {
    {
      id: id,
      name: name,
      uuid: id
    }
  }

  describe "#id" do
    it do
      expect(subject.id).to eq(id)
    end
  end

  describe "#name" do
    it do
      expect(subject.name).to eq(name)
    end
  end

  describe "#uuid" do
    it do
      expect(subject.uuid).to eq(id)
    end
  end

  describe "#to_h" do
    it do
      expect(subject.to_h).to be_a(Hash)
    end
  end
end
