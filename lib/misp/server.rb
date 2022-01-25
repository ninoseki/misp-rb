# frozen_string_literal: true

module MISP
  class Server < Base
    # @return [String]
    attr_reader :id
    # @return [String]
    attr_reader :url
    # @return [String]
    attr_reader :name

    def initialize(**attributes)
      attributes = normalize_attributes(**attributes)

      @id = attributes[:id]
      @url = attributes[:url]
      @name = attributes[:name]
    end

    #
    # Returns a hash representation of the attribute data.
    #
    # @return [Hash]
    #
    def to_h
      {
        id: id,
        url: url,
        name: name,
      }.compact
    end

    #
    # List servers
    #
    # @return [Array<MISP::Server>]
    #
    def list
      _get("/servers/") do |servers|
        servers.map do |server|
          Server.new server
        end
      end
    end

    class << self
      def list
        new.list
      end
    end
  end
end
