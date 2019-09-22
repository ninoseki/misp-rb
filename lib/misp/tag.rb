# frozen_string_literal: true

module MISP
  class Tag < Base
    attr_reader :id
    attr_reader :name
    attr_reader :colour
    attr_reader :exportable
    attr_reader :hide_tag

    def initialize(**attributes)
      attributes = normalize_attributes(attributes)

      @id = attributes.dig(:id)
      @name = attributes.dig(:name)
      @colour = attributes.dig(:colour)
      @exportable = attributes.dig(:exportable)
      @hide_tag = attributes.dig(:hide_tag)
    end

    def to_h
      {
        id: id,
        name: name,
        colour: colour,
        exportable: exportable,
        hide_tag: hide_tag,
      }.compact
    end

    def get(id)
      _get("/tags/view/#{id}") { |json| Tag.new symbolize_keys(json) }
    end

    def self.get(id)
      new.get id
    end

    def create(attributes)
      _post("/tags/add", wrap(attributes)) { |json| Tag.new symbolize_keys(json) }
    end

    def self.create(attributes)
      new.create attributes
    end

    def delete
      _post("/tags/delete/#{id}") { |json| json }
    end

    def self.delete(id)
      Tag.new(id: id).delete
    end

    def update(attributes)
      _post("/tags/edit/#{id}", wrap(attributes)) { |json| Tag.new symbolize_keys(json) }
    end

    def self.update(id, **attributes)
      Tag.new(id: id).update attributes
    end

    def search(**params)
      _post("/tags/search", params) do |tags|
        tags.map { |tag| Tag.new symbolize_keys(tag) }
      end
    end
  end
end
