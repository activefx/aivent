# frozen_string_literal: true

require_relative "aivent/version"
require "zeitwerk"
require "active_support/all"
require "dspy"

# Aivent is a library for parsing event and conference data with AI
module Aivent
  class Error < StandardError; end

  class << self
    # Returns the current configuration
    #
    # @return [Aivent::Configuration] the current configuration
    def configuration
      @configuration ||= Configuration.new
    end

    # Configures Aivent and DSPy with the given options
    #
    # @example Basic configuration
    #   Aivent.configure do |config|
    #     config.api_key = ENV["OPENROUTER_API_KEY"]
    #     config.model = "openrouter/anthropic/claude-3.5-sonnet"
    #   end
    #
    # @yield [config] Yields the configuration object for modification
    # @yieldparam config [Aivent::Configuration] the configuration object
    # @return [Aivent::Configuration] the configuration object
    def configure
      yield(configuration) if block_given?
      configuration.apply!
      configuration
    end

    # Resets the configuration to defaults
    #
    # @return [Aivent::Configuration] a new configuration object
    def reset_configuration!
      @configuration = Configuration.new
    end
  end

  loader = Zeitwerk::Loader.for_gem
  loader.setup
end
