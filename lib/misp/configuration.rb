# frozen_string_literal: true

module MISP
  class Configuration
    # @return [URI]
    attr_accessor :api_endpoint

    # @return [String]
    attr_accessor :api_key

    def initialize
      @api_endpoint = ENV["MISP_API_ENDPOINT"]
      @api_key = ENV["MISP_API_KEY"]
    end
  end

  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    attr_writer :configuration

    def configure
      yield configuration
    end
  end
end
