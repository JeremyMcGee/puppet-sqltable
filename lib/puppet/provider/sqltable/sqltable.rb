
Puppet::Type.type(:sqltable).provide(:sqltable) do

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

  def value
    @property_hash[:value]
  end

  def description
    @property_hash[:description]
  end

end
