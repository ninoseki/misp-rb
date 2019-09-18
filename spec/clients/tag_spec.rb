# frozen_string_literal: true

RSpec.describe MISP::Clients::Tag, :vcr do
  let(:api) { MISP::API.new }

  let(:tag) {
    { name: "test:created" }
  }

  describe "#create" do
    it do
      res = api.tag.create(tag)
      expect(res).to be_a(Hash)
    end
  end

  describe "#get" do
    let(:id) { api.tag.create(tag).dig("Tag", "id") }

    it do
      res = api.tag.get(id)
      expect(res).to be_a(Hash)
    end
  end

  describe "#delete" do
    let(:id) { api.tag.create(tag).dig("Tag", "id") }

    it do
      res = api.tag.delete(id)
      expect(res).to be_a(Hash)
    end
  end

  describe "#update" do
    let(:id) { api.tag.create(tag).dig("Tag", "id") }

    it do
      params = { name: "test:pre-edit" }
      res = api.tag.update(id: id, params: params)
      expect(res).to be_a(Hash)
    end
  end
end
