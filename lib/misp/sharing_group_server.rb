# frozen_string_literal: true

module MISP
  class SharingGroupServer < Server
    attr_reader :id
    attr_reader :sharing_group_id
    attr_reader :server_id
    attr_reader :all_orgs

    def initialize(**attributes)
      attributes = normalize_attributes(attributes)

      @id = attributes.dig(:id)
      @sharing_group_id = attributes.dig(:sharing_group_id)
      @server_id = attributes.dig(:server_id)
      @all_orgs = attributes.dig(:all_orgs)

      @_servers = attributes.dig(:Server) || []
    end

    def servers
      @servers ||= @_servers.map do |server|
        Server.new symbolize_keys(server)
      end
    end

    def to_h
      {
        id: id,
        sharing_group_id: sharing_group_id,
        server_id: server_id,
        all_orgs: all_orgs,
        Server: servers.map(&:to_h)
      }.compact
    end
  end
end
