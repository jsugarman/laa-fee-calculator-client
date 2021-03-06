# frozen_string_literal: true

RSpec::Matchers.define :raise_client_error do |error_klass = LAA::FeeCalculator::ClientError, error_message = //|
  match do |actual|
    actual.call
    false
  rescue StandardError => e
    @error_klass = e.class
    @error_message = e.message
    e.instance_of?(error_klass) && e.message.match?(error_message)
  end

  def supports_block_expectations?
    true
  end

  failure_message do
    if @error_klass.nil?
      "expected #{error_klass} with message matching #{error_message} but nothing was raised"
    else
      "expected #<#{@error_klass}: #{@error_message}> to match #<#{error_klass}: #{error_message}>"
    end
  end

  failure_message_when_negated do
    msg = "expected:\n"
    msg += "not to raise: #{@error_klass} with #{@error_message}\n"
    msg += "raised: #{@error_klass} with #{@error_message.nil? ? 'no error!' : "\"#{@error_message}\""}"
    msg
  end
end
