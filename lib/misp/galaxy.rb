# frozen_string_literal: true

module MISP
  class Galaxy < Base
    # @return [String]
    attr_reader :id
    # @return [String]
    attr_reader :uuid
    # @return [String]
    attr_reader :name
    # @return [String]
    attr_reader :type
    # @return [String]
    attr_reader :description
    # @return [String]
    attr_reader :version

    # @return [Array<MISP::GalaxyCluster>]
    attr_reader :galaxy_clusters

    def initialize(**attributes)
      attributes = normalize_attributes(**attributes)

      @id = attributes.dig(:id)
      @uuid = attributes.dig(:uuid)
      @name = attributes.dig(:name)
      @type = attributes.dig(:type)
      @description = attributes.dig(:description)
      @version = attributes.dig(:version)

      @galaxy_clusters = build_plural_attribute(items: attributes.dig(:GalaxyCluster), klass: GalaxyCluster)
    end

    #
    # Returns a hash representation of the attribute data.
    #
    # @return [Hash]
    #
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

    #
    # List galaxies
    #
    # @return [Array<Galaxy>]
    #
    def list
      _get("/galaxies/") do |galaxies|
        galaxies.map do |galaxy|
          Galaxy.new **galaxy
        end
      end
    end

    #
    # Get a galaxy
    #
    # @return [MISP::Galaxy]
    #
    def get
      _get("/galaxies/view/#{id}") { |galaxy| Galaxy.new **galaxy }
    end

    class << self
      def list
        new.list
      end

      def get(id)
        new(id: id).get
      end
    end
  end
end
