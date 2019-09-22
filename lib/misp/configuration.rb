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

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configuration=(config)
    @configuration = config
  end

  def self.configure
    yield configuration
  end
end
