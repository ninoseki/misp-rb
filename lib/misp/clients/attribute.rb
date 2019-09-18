# frozen_string_literal: true

module MISP
  module Clients
    class Attribute < Base
      def create(event_id:, params:)
        _post("/attributes/add/#{event_id}", wrap(params)) { |json| json }
      end

      def delete(id)
        _post("/attributes/delete/#{id}") { |json| json }
      end

      def get(id)
        _get("/attributes/#{id}") { |json| json }
      end
    end
  end
end
