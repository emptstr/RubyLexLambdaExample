require 'minitest/autorun'
require 'mocha/minitest'
require 'pathname'
require 'logger'
require 'json'
require 'yaml'

class RubyLexLambdaExampleIntegrationTest < Minitest::Test

  def setup
    @lex_client = AwsCliBasedLexClient.new
    @logger = Logger.new(STDOUT)
  end

  def test_cases
    each_test do |expected_response, actual_response|
      assert_equal(expected_response, actual_response)
    end
  end

  def each_test
    Pathname.new("#{__dir__}/data").each_child do |path|
      test_suite = YAML.load(File.read(path))
      @logger.info("Running test_suite: #{test_suite['name']} with operation: #{test_suite['operation']}")
      test_suite['testCases'].each do |test_case|
        @logger.info("Running test_case: #{test_case['name']}")
        request = test_case['request']
        actual_response = @lex_client.post_text(aws_region: 'us-west-2', bot_name: request['botName'], user_id: request['userId'], input_text: request['inputText'])
        yield(test_case['expected_response'], actual_response)
      end
    end
  end

  class AwsCliBasedLexClient
    def post_text(aws_region:, bot_name:, user_id:, input_text:)
        response = %x{aws lex-runtime post-text --region #{aws_region} --bot-name #{bot_name} --bot-alias '\$LATEST' --user-id #{user_id} --input-text '#{input_text}'}
        raise StandardError, "Failed while calling lex #{response}" unless $?.success?
        JSON.parse(response)
    end
  end
end
