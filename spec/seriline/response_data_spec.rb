require "seriline/response_data"
require "spec_helper"

RSpec.describe Seriline::ResponseData do
  # describe ".define" do
  #   it "must define a reader for each given key" do
  #     keys = %i[a b c]

  #     klass = Seriline::ResponseData.define(*keys)
  #     instance = klass.new

  #     keys.each do |key|
  #       expect(instance).to respond_to key
  #     end
  #   end

  #   it "must be able to add behaviour through block" do
  #     klass = Seriline::ResponseData.define do |klass|
  #       klass.define_method("foo") do
  #         puts "bar"
  #       end
  #     end
  #     puts klass.instance_methods.sort

  #     instance = klass.new

  #     expect(instance).to respond_to :foo
  #   end
  # end

  describe ".initialize" do
    it "must set values defined by attribute readers" do
      klass = Class.new(Seriline::ResponseData) do
        attr_reader :a, :b
      end

      instance = klass.new({ a: "1", b: "2", c: "3" })

      expect(instance.a).to eq "1"
      expect(instance.b).to eq "2"

      expect(instance).to_not respond_to :c
      expect(instance.instance_variable_get("@c")).to eq nil
    end

    it "must snake case" do
      klass = Class.new(Seriline::ResponseData) do
        attr_reader :success, :control_key, :valid_to, :abc
      end

      attributes = {
        Success: "success",
        ControlKey: "control_key",
        validTo: "valid_to",
        ABC: "abc"
      }

      instance = klass.new(attributes)

      attributes.values.each do |snake_cased_key|
        expect(instance.send(snake_cased_key)).to eq snake_cased_key.to_s
      end
    end
  end
end
