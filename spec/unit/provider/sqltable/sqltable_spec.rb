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
  end

  describe "#instances" do

    let (:table_content) do
      <<-TABLE
	key1     value1       key description
	key2     value2       second key description'
	TABLE
    end

    before do
      Dir.expects(:glob).with("/var/lib/mysql/*/Configuration.frm"). \
        returns(['/var/lib/mysql/test/Configuration.frm','/var/lib/mysql/example/Configuration.frm'])
      command = ["mysql", "-A", "-B", "-N"]
      query = "select name,value,description from %s.Configuration"
      Puppet::Util.expects(:execute).with( command + ["-e", query % "test"]).returns(table_content)
      Puppet::Util.expects(:execute).with( command + ["-e", query % "example"]).returns('k		desc')
    end

    it "gets three resources" do
      described_class.instances.should have(3).items
    end

    it "produces Sqltable instances" do
      described_class.instances.each do |instance|
        instance.should be_a(described_class)
      end
    end

  end

  describe '#exists?' do

    it "gets false if ensure not defined" do
      @provider.exists?.should be_false
    end

    it "gets false if declared absent" do
      @provider.instance_variable_get('@property_hash')[:ensure] = :absent
      @provider.exists?.should be_false
    end

    it "gets true if declared present" do
      @provider.instance_variable_get('@property_hash')[:ensure] = :present
      @provider.exists?.should be_true
    end

  end

  describe "#create" do
   it "should add a table row" do
    Puppet::Util.expects(:execute).with(["mysql", "-e", "insert into example.Config set name='thekey',value='thevalue',description='description of key'"])
    @provider.create.should == @resource.to_hash
   end
  end

  describe "#destroy" do
   before do
    @provider.instance_variable_get('@property_hash')[:database] = @resource[:database]
    @provider.instance_variable_get('@property_hash')[:table] = @resource[:table]
    @provider.instance_variable_get('@property_hash')[:key] = @resource[:key]
   end
   it "should remove a table row" do
    Puppet::Util.expects(:execute).with(["mysql", "-e", "delete from example.Config where name='thekey'"])
    @provider.destroy.should == {}
   end
  end

  describe "#flush" do
    before do
      @provider.instance_variable_set(:@property_hash, @resource.to_hash )
      @provider.instance_variable_set(:@property_flush, { :value => "new_value" } )
      Puppet::Util.expects(:execute).with(["mysql", "-e", "update example.Config set value='new_value' where name='thekey'"])
    end
    it "updates database record" do
      @provider.flush[:value].should == "new_value"
    end
  end

end
