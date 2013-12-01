
Puppet::Type.newtype(:sqltable) do

  @doc = "Manage key/value sql tables"

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
    propnames = [ :keyname , :keyvalue , :keydescr ]

    Dir.glob("/var/lib/mysql/*/%s.frm" % table).each do |frm|

      database = frm.split('/')[-2]

      command = ["mysql", "-A", "-B", "-N", "-D", :puppettest, '-e', "select %s from %s.%s" % [ columns.join(",") , database , table ] ]

      Puppet::Util.execute(command).split("\n").each do |line|
        items = line.split("\t")
        name = "%s.%s.%s" % [ database , table , items[0] ]
        obj = Puppet::Resource.new('sltable', name )
        propnames.zip( items ).each{ |k,v| obj[k] = v }
        resources << obj
      end

    end

    resources
  end

end

