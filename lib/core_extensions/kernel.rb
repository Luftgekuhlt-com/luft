# frozen_string_literal: true

require 'English'

module Kernel
  def retryable(options = {})
    opts = {
      tries: 1,              # number of retries
      on: Exception,         # the exception to rescue
      exception_filter: '',  # the the exception message must contain this to be retried
      reraise: true,         # after the final try, reraise the initial error
      failed_message: '',    # the message to append to the reraised error
      delay: 0,              # number of seconds to delay between retries
      randomize_max: 0       # set randomize max to randomize the delay
    }.merge(options)

    return nil if opts[:tries].zero?

    retry_exception = [opts[:on]].flatten
    tries = opts[:tries]
    raise_after_final_retry = opts[:reraise]
    failed_message = opts[:failed_message]
    delay = opts[:delay]
    rand_max = opts[:randomize_max]
    exception_filter = opts[:exception_filter]
    exception_regex = Regexp.new exception_filter unless exception_filter.blank?

    begin
      return yield
    rescue *retry_exception => e
      raise e unless exception_regex.nil? || exception_regex =~ e.message

      if delay.positive?
        sleep_time = delay
        sleep_time += ((rand(rand_max - delay) * 1.0) + ((rand * 100).round / 100.0)) unless rand_max.zero?
        sleep(sleep_time)
      end
      retry if (tries -= 1).positive?
      raise $ERROR_INFO, "#{failed_message} : #{$ERROR_INFO.message}" if raise_after_final_retry
    end

    yield
  end
end
