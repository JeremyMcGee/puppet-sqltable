require 'spec_helper'

describe Puppet::Type.type(:sqltable) do

  it "should have a default provider" do
    expect(described_class.defaultprovider).to_not be_nil
  end

  describe "basic structure" do

    parameters = [:name, :database, :table, :user, :password, :host]
    properties = [:key, :value, :description]

    it "should have an ensure property" do
      expect(described_class.attrtype(:ensure)).to be(:property)
    end

    properties.each do |param|
      it "should have a #{param} property" do
        expect(described_class.attrtype(param)).to be(:property)
      end
    end

    parameters.each do |param|
      it "should have a #{param} parameter" do
        expect(described_class.attrtype(param)).to be(:param)
      end
    end

  end

end
