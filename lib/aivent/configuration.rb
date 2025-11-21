# frozen_string_literal: true

module Aivent
  # Configuration class for Aivent
  #
  # Provides a simple interface to configure DSPy.rb with OpenRouter
  # or other supported LLM providers.
  #
  # @example Basic configuration with OpenRouter
  #   Aivent.configure do |config|
  #     config.api_key = ENV["OPENROUTER_API_KEY"]
  #     config.model = "openrouter/anthropic/claude-3.5-sonnet"
  #   end
  #
  # @example Configuration with custom headers for attribution
  #   Aivent.configure do |config|
  #     config.api_key = ENV["OPENROUTER_API_KEY"]
  #     config.model = "openrouter/anthropic/claude-3.5-sonnet"
  #     config.http_referrer = "https://your-app.com"
  #     config.x_title = "Your App Name"
  #   end
  #
  # @example Configuration with structured outputs disabled
  #   Aivent.configure do |config|
  #     config.api_key = ENV["OPENROUTER_API_KEY"]
  #     config.model = "openrouter/deepseek/deepseek-chat-v3.1:free"
  #     config.structured_outputs = false
  #   end
  #
  class Configuration
    # @return [String] The API key for the LLM provider
    attr_accessor :api_key

    # @return [String] The model identifier (e.g., "openrouter/anthropic/claude-3.5-sonnet")
    attr_accessor :model

    # @return [String, nil] HTTP referrer for OpenRouter attribution
    attr_accessor :http_referrer

    # @return [String, nil] Application title for OpenRouter attribution
    attr_accessor :x_title

    # @return [Boolean] Whether to use structured outputs (default: true)
    attr_accessor :structured_outputs

    # Default model to use with OpenRouter
    DEFAULT_MODEL = "openrouter/anthropic/claude-sonnet-4-20250514"

    def initialize
      @api_key = nil
      @model = DEFAULT_MODEL
      @http_referrer = nil
      @x_title = nil
      @structured_outputs = true
    end

    # Applies the configuration to DSPy
    #
    # @return [void]
    def apply!
      validate!

      DSPy.configure do |c|
        c.lm = DSPy::LM.new(model, lm_options)
      end
    end

    # Returns the options hash for DSPy::LM
    #
    # @return [Hash] The LM configuration options
    def lm_options
      options = { api_key: api_key }
      options[:http_referrer] = http_referrer if http_referrer
      options[:x_title] = x_title if x_title
      options[:structured_outputs] = structured_outputs unless structured_outputs
      options
    end

    private

    def validate!
      raise ConfigurationError, "API key is required" if api_key.nil? || api_key.empty?
      raise ConfigurationError, "Model is required" if model.nil? || model.empty?
    end
  end

  # Error raised when configuration is invalid
  class ConfigurationError < Error; end
end
