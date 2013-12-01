
Puppet::Type.type(:sqltable).provide(:sqltable) do

  def self.prefetch(resources)
    keypairs = self.instances
    resources.keys.each do |name|
      if provider = keypairs.find{ |k| k.name == name }
        resources[name].provider = provider
      end
    end
  end

  def self.instances
    resources = []

    table = "Configuration"
    columns = [ 'name' , 'value' , 'description' ]
    propnames = [ :key , :value , :description ]

    Dir.glob("/var/lib/mysql/*/%s.frm" % table).each do |frm|

      database = frm.split('/')[-2]

      command = ["mysql", "-A", "-B", "-N", "-D", :puppettest, '-e', "select %s from %s.%s" % [ columns.join(",") , database , table ] ]

      Puppet::Util.execute(command).split("\n").each do |line|
        items = line.split("\t")
        resources << new( :name => "%s.%s.%s" % [ database , table , items[0] ] ,
                          :ensure => :present ,
                          :key => items[0] ,
                          :value => items[1] ,
                          :description => items[2] )
      end

    end

    resources
  end

  def exists?
    !(@property_hash[:ensure] == :absent or @property_hash[:ensure].nil?)
  end

  def key
    @property_hash[:key]
  end

  def key=(newkey)
    @property_hash[:key] = newkey
  end

  def value
    @property_hash[:value]
  end

  def value=(newvalue)
    @property_hash[:value] = newvalue
  end

  def description
    @property_hash[:description]
  end

  def description=(newdesc)
    @property_hash[:description] = newdesc
  end

end
