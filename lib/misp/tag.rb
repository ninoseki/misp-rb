# frozen_string_literal: true

module MISP
  class Tag < Base
    # @return [String]
    attr_accessor :id
    # @return [String]
    attr_accessor :name
    # @return [String]
    attr_accessor :colour
    # @return [Boolean]
    attr_accessor :exportable
    # @return [Boolean]
    attr_accessor :hide_tag

    def initialize(**attributes)
      attributes = normalize_attributes(**attributes)

      @id = attributes.dig(:id)
      @name = attributes.dig(:name)
      @colour = attributes.dig(:colour)
      @exportable = attributes.dig(:exportable)
      @hide_tag = attributes.dig(:hide_tag)
    end

    #
    # Returns a hash representation of the attribute data.
    #
    # @return [Hash]
    #
    def to_h
      {
        id: id,
        name: name,
        colour: colour,
        exportable: exportable,
        hide_tag: hide_tag,
      }.compact
    end

    #
    # Get a tag
    #
    # @return [MISP::Tag]
    #
    def get
      _get("/tags/view/#{id}") { |json| Tag.new(**json) }
    end

    #
    # Create a tag
    #
    # @param [Hash] **attributes attributes
    #
    # @return [MISP::Tag]
    #
    def create(**attributes)
      _post("/tags/add", wrap(attributes)) { |json| Tag.new(**json) }
    end

    #
    # Delete a tag
    #
    # @return [Hash]
    #
    def delete
      _post("/tags/delete/#{id}") { |json| json }
    end

    #
    # Update a tag
    #
    # @param [Hash] **attributes attributes
    #
    # @return [MISP::Tag]
    #
    def update(**attributes)
      payload = to_h.merge(attributes)
      _post("/tags/edit/#{id}", wrap(payload)) { |json| Tag.new(**json) }
    end

    #
    # Search for tags
    #
    # @param [Hash] **params parameters
    #
    # @return [MISP::Tag]
    #
    def search(**params)
      _post("/tags/search", params) do |tags|
        tags.map { |tag| Tag.new tag }
      end
    end

    class << self
      def get(id)
        new(id: id).get
      end

      def create(**attributes)
        new.create(**attributes)
      end

      def delete(id)
        Tag.new(id: id).delete
      end

      def update(id, **attributes)
        Tag.new(id: id).update(**attributes)
      end
    end
  end
end
