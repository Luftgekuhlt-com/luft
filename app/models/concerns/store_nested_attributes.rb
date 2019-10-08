# Allows you to save a collection of attributes in a store column with
# the ability to deserialize them as a particular Object of +class_name+.
#
# When you enable store nested attributes an attribute writer is defined
# on the model and the store accessor is overridden to return objects
# rather than the stored value.
#
# class Book < ActiveRecord::Base
#   include StoreNestedAttributes
#
#   store :content, accessors: [:authors], coder: JSON
#
#   accepts_store_nested_attributes_for :authors, "Author"
# end
#
# class Author
#   include ActiveModel::Model
#
#   attr_accessor :id, :name
#
#   def persisted?
#     id.present?
#   end
# end
#
# The attribute writer is named after the accessor, which means that in the
# previous example a new method is added to the Book model.
#
# authors_attributes=(attributes)
module StoreNestedAttributes
  extend ActiveSupport::Concern

  class_methods do
    # Overrides store accessor and defines an attribute writer method for the
    # specified store accessor.
    #
    # +attribute+ - Symbol
    #   Name of the store accessor
    # +class_name+ - String
    #   Name of the class used in deserialization of stored attributes.
    #
    #   Classes must have a constructor that can populate attributes through
    #   mass-assignment (e.g. Author.new(name: "Dr. Suess", nickname: "Doc")).
    #
    #   Classes that respond to #id and #id= will cause the attribute
    #   writer to do the following:
    #     - If an attribute hash does not contain an "id" key, an "id" key
    #       will be set to a random value.
    #     - If an attribute hash contains an "id" key, the value will be
    #       used to first locate the record and if found update the stored
    #       attributes or else insert the attribute hash.
    #   Classes must also respond to #persisted?, particularly when working
    #   with fields_for.
    #
    #   See Author model above for an example that meets all the above requirements.
    # +options+ - Hash
    #   :reject_if
    #     A Proc that checks whether a certain attribute hash should be ignored.
    def accepts_store_nested_attributes_for(attribute, class_name, options = {})
      klass = const_get(class_name)
      ivar = :"@#{attribute}"
      store_key = stored_attributes.find { |k,v| v.include?(attribute) }.first

      # def qualifications_with_conversion
      #   attributes = content[:qualifications]
      #
      #   return [] if attributes.blank?
      #
      #   @qualifications ||= attributes.map do |attrs|
      #     Resume::Qualification.new(attrs)
      #   end
      # end
      #
      # alias_method_chain :qualifications, :conversion
      define_method(:"#{attribute}") do
        attributes = send(store_key)[attribute]

        return [] if attributes.blank?

        if instance_variable_get(ivar).nil?
          collection = attributes.map do |attrs|
            klass.new(attrs)
          end

          instance_variable_set(ivar, collection)
        end

        instance_variable_get(ivar)
      end

      # def qualifications_attributes=(attributes)
      #   attributes = attributes.values
      #   attributes = attributes.values.reject(&options[:reject_if]) if options[:reject_if]
      #
      #   if Resume::Qualification.method_defined?(:id=)
      #     current_attributes = content[:qualifications] || []
      #
      #     attributes.each do |attrs|
      #       attrs["id"] ||= SecureRandom.hex
      #
      #       if index = current_attributes.index { |data| data["id"] == attrs["id"] }
      #         current_attributes[index] = current_attributes[index].merge!(attrs)
      #       else
      #         current_attributes.push(attrs)
      #       end
      #     end
      #
      #     content[:qualifications] = current_attributes
      #   else
      #     content[:qualifications] = attributes
      #   end
      #
      #   @qualifications = nil
      # end
      define_method(:"#{attribute}_attributes=") do |attributes|
        attributes = attributes.values
        attributes = attributes.reject(&options[:reject_if]) if options[:reject_if]

        if klass.method_defined?(:id=)
          current_attributes = send(store_key)[attribute] || []

          attributes.each do |attrs|
            attrs["id"] ||= SecureRandom.hex

            if index = current_attributes.index { |data| data["id"] == attrs["id"] }
              current_attributes[index] = current_attributes[index].merge!(attrs)
            else
              current_attributes.push(attrs)
            end
          end

          send(store_key)[attribute] = current_attributes
        else
          send(store_key)[attribute] = attributes
        end

        instance_variable_set(ivar, nil)
      end
    end
  end
end