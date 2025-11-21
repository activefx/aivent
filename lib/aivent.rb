# frozen_string_literal: true

require_relative "aivent/version"
require "zeitwerk"
require "active_support/all"

# Aivent is a library for parsing event and conference data with AI
module Aivent
  class Error < StandardError; end

  loader = Zeitwerk::Loader.for_gem
  loader.setup
end
