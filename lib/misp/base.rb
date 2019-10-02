# frozen_string_literal: true

require "json"
require "net/https"
require "uri"

module MISP
  class Base
    private

    def api_endpoint
      @api_endpoint ||= URI(MISP.configuration.api_endpoint)
    end

    def api_key
      @api_key ||= MISP.configuration.api_key
    end

    def build_attribute(item:, klass:)
      return nil unless item

      klass.new item
    end

    def build_plural_attribute(items:, klass:)
      (items || []).map do |item|
        klass.new item
      end
    end

    def class_name
      self.class.to_s.split("::").last.to_s
    end

    def normalize_attributes(attributes)
      klass = class_name.to_sym

      attributes.key?(klass) ? attributes.dig(klass) : attributes
    end

    def wrap(params)
      klass = class_name.to_sym
      return params if params.key?(klass)

      [[klass, params]].to_h
    end

    def hostname
      @hostname ||= api_endpoint.hostname
    end

    def port
      @port ||= api_endpoint.port
    end

    def scheme
      @scheme ||= api_endpoint.scheme
    end

    def base_url
      "#{scheme}://#{hostname}:#{port}"
    end

    def url_for(path)
      URI(base_url + path)
    end

    def https_options
      return nil if scheme != "https"

      if proxy = ENV["HTTPS_PROXY"] || ENV["https_proxy"]
        uri = URI(proxy)
        {
          proxy_address: uri.hostname,
          proxy_port: uri.port,
          proxy_from_env: false,
          use_ssl: true,
        }
      else
        { use_ssl: true }
      end
    end

    def http_options
      if proxy = ENV["HTTP_PROXY"] || ENV["http_proxy"]
        uri = URI(proxy)
        {
          proxy_address: uri.hostname,
          proxy_port: uri.port,
          proxy_from_env: false,
        }
      else
        {}
      end
    end

    def parse_body(body)
      JSON.parse body.to_s, symbolize_names: true
    rescue JSON::ParserError => _e
      body.to_s
    end

    def request(req)
      Net::HTTP.start(hostname, port, https_options || http_options) do |http|
        req.initialize_http_header default_headers

        response = http.request(req)
        json = parse_body(response.body)

        code = response.code
        unless code.start_with? "20"
          raise Error, "Unsupported response code returned: #{code} (#{json})"
        end

        yield json
      end
    end

    def default_headers
      {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": api_key
      }
    end

    def _get(path, params = {}, &block)
      url = url_for(path)
      url.query = URI.encode_www_form(params) unless params.empty?

      get = Net::HTTP::Get.new(url)
      request(get, &block)
    end

    def _post(path, params = {}, &block)
      url = url_for(path)

      post = Net::HTTP::Post.new(url)
      post.body = params.is_a?(Hash) ? params.to_json : params.to_s

      request(post, &block)
    end

    def _delete(path, params = {}, &block)
      url = url_for(path)
      url.query = URI.encode_www_form(params) unless params.empty?

      delete = Net::HTTP::Delete.new(url)
      request(delete, &block)
    end
  end
end
