
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

      command = ["mysql", "-A", "-B", "-N", "-e", "select %s from %s.%s" % [ columns.join(",") , database , table ] ]

      Puppet::Util.execute(command).split("\n").each do |line|
        items = line.split("\t")
        resources << new( :name => "%s.%s.%s" % [ database , table , items[0] ] ,
                          :ensure => :present ,
                          :value => items[1] ,
                          :description => items[2] )
      end

    end

    resources
  end

  def exists?
    !(@property_hash[:ensure] == :absent or @property_hash[:ensure].nil?)
  end

  def create

    columns = [ 'name' , 'value' , 'description' ]
    propnames = [ :key , :value , :description ]
    namesmap = Hash[ propnames.zip( columns ) ]

    newvalueses = []
    propnames.each do |k|
      newvalueses << "%s='%s'" % [ namesmap[k] , resource[k] ]
    end

    command = ["mysql", "-e", "insert into %s.%s set %s" % [ resource[:database] , resource[:table] , newvalueses.join(',') ] ]
    if not resource[:username].to_s.empty?
        command.push( "--user=%s" % resource[:username] )
    end
    if not resource[:password].to_s.empty?
        command.push( "--password=%s" % resource[:password] )
    end
    Puppet::Util.execute(command)

    @property_hash = resource.to_hash
  end

  def destroy
    command = ["mysql", "-e", "delete from %s.%s where name='%s'" % [ @property_hash[:database] , resource[:table] , @property_hash[:key] ] ]
    if not resource[:username].to_s.empty?
        command.push( "--user=%s" % resource[:username] )
    end
    if not resource[:password].to_s.empty?
        command.push( "--password=%s" % resource[:password] )
    end
    Puppet::Util.execute(command)
    @property_hash.clear
  end

  def initialize(value={})
    super(value)
    @property_flush = {}
  end

  def flush

    if not @property_flush.empty?

      newvalueses = []
      @property_flush.each do |k,v|
        newvalueses << "%s='%s'" % [ k , v ]
      end

      command = ["mysql", "-e", "update %s.%s set %s where name='%s'" % [ @property_hash[database] , @property_hash[table] , newvalueses.join(',') , @property_hash[:key] ] ]
      if not resource[:username].to_s.empty?
        command.push( "--user=%s" % resource[:username] )
      end
      if not resource[:password].to_s.empty?
        command.push( "--password=%s" % resource[:password] )
      end
      Puppet::Util.execute(command)

    end

    @property_hash = resource.to_hash
  end

  def key
    @property_hash[:key]
  end

  def key=(newkey)
    @property_flush[:key] = newkey
  end

  def value
    @property_hash[:value]
  end

  def value=(newvalue)
    @property_flush[:value] = newvalue
  end

  def description
    @property_hash[:description]
  end

  def description=(newdesc)
    @property_flush[:description] = newdesc
  end

end
