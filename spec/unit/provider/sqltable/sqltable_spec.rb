require "spec_helper"

describe Puppet::Type.type(:sqltable).provider(:sqltable) do

  before :each do
    @resource = Puppet::Type.type(:sqltable).new(
                     :name   => 'example.Config.thekey',
                     :ensure => :present ,
                     :key    => "thekey" ,
                     :value  => "thevalue" ,
                     :table  => "Config" ,
                     :database => "example" ,
                     :description => "description of key"
                   )
    @provider = described_class.new( @resource )
    # Required for destroy test
    @provider.instance_variable_get('@property_hash')[:database] = @resource[:database]
    @provider.instance_variable_get('@property_hash')[:table] = @resource[:table]
    @provider.instance_variable_get('@property_hash')[:key] = @resource[:key]
  end

  [ :create,
    :destroy,
    :exists?
    ].each do |method|
    it "should respond to method #{method} called" do
      @provider.should respond_to(method)
    end
  end

  it "should add a row" do
    Puppet::Util.expects(:execute).with(["mysql", "-e", "insert into example.Config set name='thekey',value='thevalue',description='description of key'"])
    @provider.create.should == @resource.to_hash
  end

  it "should remove a row" do
    Puppet::Util.expects(:execute).with(["mysql", "-e", "delete from example.Config where name='thekey'"])
    @provider.destroy == {}
  end

end
