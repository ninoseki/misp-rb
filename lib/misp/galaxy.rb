# frozen_string_literal: true

module MISP
  class Galaxy < Base
    attr_reader :id
    attr_reader :uuid
    attr_reader :name
    attr_reader :type
    attr_reader :description
    attr_reader :version

    attr_reader :galaxy_clusters

    def initialize(**attributes)
      attributes = normalize_attributes(attributes)

      @id = attributes.dig(:id)
      @uuid = attributes.dig(:uuid)
      @name = attributes.dig(:name)
      @type = attributes.dig(:type)
      @description = attributes.dig(:description)
      @version = attributes.dig(:version)

      @galaxy_clusters = build_plural_attribute(items: attributes.dig(:GalaxyCluster), klass: GalaxyCluster)
    end

    def to_h
      {
        id: id,
        uuid: uuid,
        name: name,
        type: type,
        description: description,
        version: version,
        GalaxyCluster: galaxy_clusters.map(&:to_h)
      }.compact
    end

    def list
      _get("/galaxies/") do |galaxies|
        galaxies.map do |galaxy|
          Galaxy.new symbolize_keys(galaxy)
        end
      end
    end

    def self.list
      new.list
    end

    def get
      _get("/galaxies/view/#{id}") { |galaxy| Galaxy.new symbolize_keys(galaxy) }
    end

    def self.get(id)
      new(id: id).get
    end
  end
end
