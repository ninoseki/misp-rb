# frozen_string_literal: true

RSpec.describe MISP::Clients::Event, :vcr do
  let(:api) { MISP::API.new }

  let(:event) {
    {
      Event: {
        info: "teast"
      }
    }
  }

  describe "#list" do
    it do
      res = api.event.list
      expect(res).to be_an(Array)
    end
  end

  describe "#create" do
    it do
      res = api.event.create(event)
      expect(res).to be_a(Hash)
    end
  end

  describe "#get" do
    let(:id) { api.event.create(event).dig("Event", "id") }

    it do
      res = api.event.get(id)
      expect(res).to be_a(Hash)
    end
  end

  describe "#delete" do
    let(:id) { api.event.create(event).dig("Event", "id") }

    it do
      res = api.event.delete(id)
      expect(res).to be_a(Hash)
    end
  end

  describe "#update" do
    let(:id) { api.event.create(event).dig("Event", "id") }

    it do
      params = { info: "new info" }
      res = api.event.update(id: id, params: params)
      expect(res).to be_a(Hash)
    end
  end
end
