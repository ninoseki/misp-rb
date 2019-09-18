# frozen_string_literal: true

RSpec.describe MISP::Clients::Attribute, :vcr do
  let(:api) { MISP::API.new }

  let(:event_id) { api.event.create(event).dig("Event", "id") }
  let(:event) { { info: "test" } }

  let(:attribute) {
    {
      value: "8.8.8.8",
      type: "ip-dst"
    }
  }

  describe "#create" do
    it do
      res = api.attribute.create(event_id: event_id, params: attribute )
      expect(res).to be_a(Hash)
    end
  end

  describe "#get" do
    let(:id) { api.attribute.create(event_id: event_id, params: attribute).dig("Attribute", "id") }

    it do
      res = api.attribute.get(id)
      expect(res).to be_a(Hash)
    end
  end

  describe "#delete" do
    let(:id) { api.attribute.create(event_id: event_id, params: attribute).dig("Attribute", "id") }

    it do
      res = api.attribute.delete(id)
      expect(res).to be_a(Hash)
    end
  end
end
