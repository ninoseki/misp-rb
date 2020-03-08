# frozen_string_literal: true

RSpec.describe MISP::SharingGroupServer do
  subject { described_class.new **attributes }

  let(:attributes) {
    { all_orgs: true, server_id: "0", sharing_group_id: "1", Server: [] }
  }

  describe "#all_orgs" do
    it do
      expect(subject.all_orgs).to eq(true)
    end
  end

  describe "#server_id" do
    it do
      expect(subject.server_id).to eq("0")
    end
  end

  describe "#sharing_group_id" do
    it do
      expect(subject.sharing_group_id).to eq("1")
    end
  end

  describe "#servers" do
    it do
      expect(subject.servers).to be_an(Array)
    end
  end

  describe "#to_h" do
    it do
      expect(subject.to_h).to be_a(Hash)
    end
  end
end
