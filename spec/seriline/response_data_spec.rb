require "seriline/response_data"
require "spec_helper"

RSpec.describe Seriline::ResponseData do
  describe "#success?" do
    let(:klass) do
      Class.new(Seriline::ResponseData) do
        attr_reader :success
      end
    end

    it "must have a default implementation" do
      expect(klass.new).to respond_to :success?
    end

    it "must be true if the success attribute is true" do
      instance = klass.new(success: true)

      expect(instance.success?).to eq true
    end

    it "must be false if the success attribute is false" do
      instance = klass.new(success: false)

      expect(instance.success?).to eq false
    end
  end

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
