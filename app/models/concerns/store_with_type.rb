module StoreWithType
  extend ActiveSupport::Concern

  TYPES = {
    date: ActiveRecord::Type::Date,
    boolean: ActiveRecord::Type::Boolean,
    integer: ActiveRecord::Type::Integer
  }

  VALIDATIONS = {
    integer: ->(value) { value.present? }
  }

  class_methods do
    #
    # .store_accessor_with_type allows you to handle type casting of stored attributes
    # on your ActiveRecord models using the ActiveRecord::Store module.
    #
    # - Parameters
    #
    #   +store_column+ - Symbol
    #     The name of the column in the database that contains the stored content
    #   +attributes+ - Hash
    #     :key - the name of the accessor attribute
    #     :value - can be of type Symbol or a Hash of options.
    #       Symbol - the type of the attribute (e.g. :date, :boolean)
    #       Hash - the options for the attribute
    #         :type - the type key is required and represents the type of the attribute
    #         :default - the default value to assign the attribute if it is not set
    #
    # - Examples
    #
    #   store_accessor_with_type :content, expires_on: :date
    #   store_accessor_with_type :content, current: { type: :boolean, default: false }
    #   store_accessor_with_type :content, expires_on: :date, current: { type: :boolean, default: false }
    #
    def store_accessor_with_type(store_column, attributes)
      # use built-in ActiveRecord::Store to add accessors for the attributes requested
      store_accessor(store_column, *attributes.keys)

      # see Parameters section above.
      attributes.each do |name, type_or_options|
        options = if type_or_options.is_a?(Hash)
          type_or_options
        else
          { type: type_or_options }
        end

        if type = TYPES[options[:type]]
          column = ActiveRecord::ConnectionAdapters::Column.new(name, options[:default], type.new)

          self.columns_hash[name.to_s] = column

          # override the getter method to type cast prior to returning the value
          #
          # def expires_on
          #   self.class.columns_hash["expires_on"].type_cast_from_database(super)
          # end
          #
          define_method(name) do
            if validation = VALIDATIONS[options[:type]]
              return unless validation.call(super())
            end

            self.class.columns_hash[name.to_s].type_cast_from_database(super())
          end

          # create alias by appending ? for accessors of type boolean
          alias_method :"#{name}?", name if options[:type] == :boolean
        else
          raise "#{options[:type]} is currently not supported"
        end
      end
    end
  end
end