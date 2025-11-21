# frozen_string_literal: true

require "test_helper"

class TestConfiguration < Minitest::Test
  def setup
    Aivent.reset_configuration!
  end

  def test_default_model
    config = Aivent::Configuration.new

    assert_equal "openrouter/anthropic/claude-sonnet-4-20250514", config.model
  end

  def test_default_structured_outputs
    config = Aivent::Configuration.new

    assert config.structured_outputs
  end

  def test_default_api_key_is_nil
    config = Aivent::Configuration.new

    assert_nil config.api_key
  end

  def test_can_set_api_key
    config = Aivent::Configuration.new
    config.api_key = "test-api-key"

    assert_equal "test-api-key", config.api_key
  end

  def test_can_set_model
    config = Aivent::Configuration.new
    config.model = "openrouter/deepseek/deepseek-chat-v3.1:free"

    assert_equal "openrouter/deepseek/deepseek-chat-v3.1:free", config.model
  end

  def test_can_set_http_referrer
    config = Aivent::Configuration.new
    config.http_referrer = "https://example.com"

    assert_equal "https://example.com", config.http_referrer
  end

  def test_can_set_x_title
    config = Aivent::Configuration.new
    config.x_title = "My App"

    assert_equal "My App", config.x_title
  end

  def test_can_set_structured_outputs
    config = Aivent::Configuration.new
    config.structured_outputs = false

    refute config.structured_outputs
  end

  def test_lm_options_basic
    config = Aivent::Configuration.new
    config.api_key = "test-key"

    options = config.lm_options

    assert_equal({ api_key: "test-key" }, options)
  end

  def test_lm_options_with_http_referrer
    config = Aivent::Configuration.new
    config.api_key = "test-key"
    config.http_referrer = "https://example.com"

    options = config.lm_options

    assert_equal "https://example.com", options[:http_referrer]
  end

  def test_lm_options_with_x_title
    config = Aivent::Configuration.new
    config.api_key = "test-key"
    config.x_title = "My App"

    options = config.lm_options

    assert_equal "My App", options[:x_title]
  end

  def test_lm_options_with_structured_outputs_disabled
    config = Aivent::Configuration.new
    config.api_key = "test-key"
    config.structured_outputs = false

    options = config.lm_options

    refute options[:structured_outputs]
  end

  def test_lm_options_without_structured_outputs_when_enabled
    config = Aivent::Configuration.new
    config.api_key = "test-key"
    config.structured_outputs = true

    options = config.lm_options

    refute options.key?(:structured_outputs)
  end

  def test_validation_raises_on_nil_api_key
    config = Aivent::Configuration.new
    config.api_key = nil

    error = assert_raises(Aivent::ConfigurationError) do
      config.send(:validate!)
    end
    assert_equal "API key is required", error.message
  end

  def test_validation_raises_on_empty_api_key
    config = Aivent::Configuration.new
    config.api_key = ""

    error = assert_raises(Aivent::ConfigurationError) do
      config.send(:validate!)
    end
    assert_equal "API key is required", error.message
  end

  def test_validation_raises_on_nil_model
    config = Aivent::Configuration.new
    config.api_key = "test-key"
    config.model = nil

    error = assert_raises(Aivent::ConfigurationError) do
      config.send(:validate!)
    end
    assert_equal "Model is required", error.message
  end

  def test_validation_raises_on_empty_model
    config = Aivent::Configuration.new
    config.api_key = "test-key"
    config.model = ""

    error = assert_raises(Aivent::ConfigurationError) do
      config.send(:validate!)
    end
    assert_equal "Model is required", error.message
  end
end

class TestAiventConfiguration < Minitest::Test
  def setup
    Aivent.reset_configuration!
  end

  def test_configuration_returns_configuration_object
    assert_instance_of Aivent::Configuration, Aivent.configuration
  end

  def test_configuration_returns_same_object
    config1 = Aivent.configuration
    config2 = Aivent.configuration

    assert_same config1, config2
  end

  def test_reset_configuration_creates_new_object
    config1 = Aivent.configuration
    Aivent.reset_configuration!
    config2 = Aivent.configuration

    refute_same config1, config2
  end

  def test_configuration_error_inherits_from_error
    assert_operator Aivent::ConfigurationError, :<, Aivent::Error
  end
end
