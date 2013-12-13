require 'spec_helper'

describe Puppet::Type.type(:sqltable) do

  it "should have a default provider" do
    described_class.defaultprovider.should_not be_nil
  end

  describe "basic structure" do

    parameters = [:name, :database, :table, :user, :password, :host]
    properties = [:key, :value, :description]

    it "should have an ensure property" do
      described_class.attrtype(:ensure).should == :property
    end

    properties.each do |param|
      it "should have a #{param} property" do
        described_class.attrtype(param).should == :property
      end
    end

    parameters.each do |param|
      it "should have a #{param} parameter" do
        described_class.attrtype(param).should == :param
      end
    end

  end

end
