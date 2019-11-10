class Conf
  class Error < StandardError; end
  class NotConfigured < Error; end
  class MissingKey < Error; end

  class << self
    class_attribute :files

    self.files = []

    def load(*files)
      self.files.push(*files)

      files.each do |file|
        config_for(file).each do |k, v|
          define_singleton_method(k) { v }
        end
      end
    end

    def method_missing(method, *args, &block)
      if files.any?
        CounterHelper.increment("conf:missing_key:#{method}")

        raise MissingKey, "#{method}: define in one of the following files: #{files.join(", ")}"
      else
        raise NotConfigured, 'call .load to configure.'
      end
    end

    private

    def config_for(file)
      Rails.application.config_for(File.basename(file).gsub('.yml', ''))
    end
  end
end
