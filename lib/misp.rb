# frozen_string_literal: true

require "misp/version"

require "misp/clients/base"

require "misp/clients/event"
require "misp/clients/attribute"
require "misp/clients/tag"

require "misp/api"

module MISP
  class Error < StandardError; end
end
