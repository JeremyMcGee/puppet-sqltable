
Puppet::Type.newtype(:sqltable) do

  @doc = "Manage key/value sql tables"

  ensurable

  newparam(:name, :namevar => true) do
    desc "resource name"
  end

  newproperty(:key) do
    desc "parameter name"
  end

  newproperty(:value) do
    desc "parameter value"
  end

  newproperty(:description) do
    desc "parameter description"
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
                          :key => items[0] ,
                          :value => items[1] ,
                          :description => items[2] )
      end

    end

    resources
  end

end

