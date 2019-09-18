# frozen_string_literal: true

module MISP
  module Clients
    class Event < Base
      def get(id)
        _get("/events/#{id}") { |json| json }
      end

      def create(params)
        _post("/events/add", wrap(params)) { |json| json }
      end

      def delete(id)
        _delete("/events/#{id}") { |json| json }
      end

      def list
        _get("/events/index") { |json| json }
      end

      def update(id:, params:)
        _post("/events/#{id}", wrap(params)) { |json| json }
      end
    end
  end
end
