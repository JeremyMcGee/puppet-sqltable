require 'spec_helper'

sqltable = Puppet::Type.type(:sqltable)

describe sqltable do

  it "should have a default provider" do
    Puppet::Type.type(:sqltable).defaultprovider.should_not be_nil
  end

  describe "basic structure" do

    parameters = [:name, :database, :table]
    properties = [:key, :value, :description]

    it "should have an ensure property" do
      Puppet::Type.type(:sqltable).attrtype(:ensure).should == :property
    end

    properties.each do |param|
      it "should have a #{param} property" do
        Puppet::Type.type(:sqltable).attrtype(param).should == :property
      end
    end

    parameters.each do |param|
      it "should have a #{param} parameter" do
        Puppet::Type.type(:sqltable).attrtype(param).should == :param
      end
    end

  end

end
