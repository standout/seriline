
# This class represents a simple struct like object.
# - Permitted attributes must be defined with `attr_reader`
# - When initialized attribute keys will be snake cased.
#   For example { CamelCase: "Hello world!" }
#   would set the instance variable @camel_case
#
# Example:
#
# class PersonResponse < Seriline::ResponseData
#   attr_reader :name, :email
# end
#
# PersonResponse.new({
#   name: "Bob",
#   email: "bob-the-builder@gmail.com",
#   password: "secret"
# })
#
#=> #<PersonResponse:0x007fca321df778 @name="Bob", @email="bob-the-builder@gmail.com">
module Seriline
  class ResponseData
    def initialize(attributes = {})
      attributes.each do |attribute, value|
        reader_name = snake_case(attribute)
        next unless respond_to? reader_name
        instance_variable_set("@#{reader_name}", value)
      end
    end

    def success?
      success
    end

    private

    def snake_case(string)
      string = string.to_s
      scan = string.scan(/[A-Z]*[a-z]+/)
      return string.downcase if scan.empty?
      scan.map(&:downcase) * "_"
    end
  end
end
