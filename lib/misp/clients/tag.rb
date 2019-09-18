# frozen_string_literal: true

module MISP
  module Clients
    class Tag < Base
      def get(id)
        _get("/tags/view/#{id}") { |json| json }
      end

      def create(params)
        _post("/tags/add", wrap(params)) { |json| json }
      end

      def delete(id)
        _post("/tags/delete/#{id}") { |json| json }
      end

      def update(id:, params:)
        _post("/tags/edit/#{id}", wrap(params)) { |json| json }
      end
    end
  end
end
