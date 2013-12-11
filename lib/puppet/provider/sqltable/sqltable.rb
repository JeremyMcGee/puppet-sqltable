
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
                          :database => database ,
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

  def create
    database = resource[:database] || resource.name.split('.')[0]
    table = "Configuration"

    columns = [ 'name' , 'value' , 'description' ]
    propnames = [ :key , :value , :description ]
    namesmap = Hash[ propnames.zip( columns ) ]

    newvalueses = []
    propnames.each do |k|
      newvalueses << "%s='%s'" % [ namesmap[k] , resource[k] ]
    end

    command = ["mysql", "-e", "insert into %s.%s set %s" % [ database , table , newvalueses.join(',') ] ]
    if not resource[:username].empty?
        command.push( "--user=%s" % resource[:username] )
    end
    if not resource[:password].empty?
        command.push( "--password=%s" % resource[:password] )
    end
    Puppet::Util.execute(command)

    @property_hash = resource.to_hash
  end

  def destroy
    # What about database given on resource description
    database , table , name = resource.name.split('.',3)
    command = ["mysql", "-e", "delete from %s.%s where name='%s'" % [ database , table , @property_hash[:key] ] ]
    if not resource[:username].empty?
        command.push( "--user=%s" % resource[:username] )
    end
    if not resource[:password].empty?
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
    database = @property_hash[:database] || resource.name.split('.')[0]
    table = "Configuration"

    if not @property_flush.empty?

      newvalueses = []
      @property_flush.each do |k,v|
        newvalueses << "%s='%s'" % [ k , v ]
      end

      command = ["mysql", "-e", "update %s.%s set %s where name='%s'" % [ database , table , newvalueses.join(',') , @property_hash[:key] ] ]
      if not resource[:username].empty?
        command.push( "--user=%s" % resource[:username] )
      end
      if not resource[:password].empty?
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
