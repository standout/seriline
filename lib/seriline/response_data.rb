module Seriline
  class ResponseData
    def initialize(attributes)
      attributes.each do |attribute, value|
        reader_name = snake_case(attribute.to_s)
        self.class.send(:attr_reader, reader_name)
        instance_variable_set("@#{reader_name}", value)
      end
    end

    private

    def snake_case(string)
      scan = string.scan(/[A-Z]*[a-z]+/)
      return string.downcase if scan.empty?
      scan.map(&:downcase) * "_"
    end
  end
end
