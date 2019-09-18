# frozen_string_literal: true

module MISP
  class API
    attr_reader :event
    attr_reader :tag
    attr_reader :attribute

    def initialize(api_endpoint: ENV["MISP_API_ENDPOINT"], api_key: ENV["MISP_API_KEY"])
      @api_endpoint = api_endpoint
      @api_key = api_key

      @event = Clients::Event.new(api_endpoint: @api_endpoint, api_key: @api_key)
      @tag = Clients::Tag.new(api_endpoint: @api_endpoint, api_key: @api_key)
      @attribute = Clients::Attribute.new(api_endpoint: @api_endpoint, api_key: @api_key)
    end
  end
end
