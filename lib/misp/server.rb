# frozen_string_literal: true

module MISP
  class Server < Base
    attr_reader :id
    attr_reader :url
    attr_reader :name

    def initialize(**attributes)
      attributes = normalize_attributes(attributes)

      @id = attributes.dig(:id)
      @url = attributes.dig(:url)
      @name = attributes.dig(:name)
    end

    def to_h
      {
        id: id,
        url: url,
        name: name,
      }.compact
    end

    def list
      _get("/servers/") do |servers|
        servers.map do |server|
          Server.new symbolize_keys(server)
        end
      end
    end

    def self.list
      new.list
    end
  end
end
