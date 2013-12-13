
Puppet::Type.newtype(:sqltable) do

  @doc = "Manage key/value sql tables"

  ensurable

  # Workaround until issue #4049 gets fixed
  validate do
    required_params = [ :key , :database ]
    missing = required_params.select{ |param| self[param].nil? }
    fail( '%s: %s required' % [ self , missing.join(", ") ] ) unless missing.empty?
  end

  newparam(:name, :namevar => true) do
    desc "resource name"
    validate do |value|
      components = value.split('.')
      if components.length == 3
        resource[:database] = components[0]
        resource[:table] = components[1]
        resource[:key] = components[2]
      end
    end
  end

  newproperty(:key, :required => true ) do
    desc "parameter name"
    validate do |value|
      if not resource[:key].nil? and value != resource[:key]
        fail( "Conflicting values for key name : %s vs %s" % [ value , resource[:key] ] )
      end
    end
  end

  newproperty(:value) do
    desc "parameter value"
  end

  newproperty(:description) do
    desc "parameter description"
  end

  newparam(:table) do
    desc "database table"
    defaultto :Configuration
    validate do |value|
      if not resource[:table].nil?
        if value != resource[:table]
          fail( "Conflicting values for key name : %s vs %s" % [ value , resource[:table] ] )
        end
      end
    end
  end

  newparam(:database, :required => true ) do
    desc "database name"
    validate do |value|
      if not resource[:database].nil? and value != resource[:database]
        fail( "Conflicting values for database : %s vs %s" % [ value , resource[:database] ] )
      end
    end
  end

  newparam(:host) do
    desc "remote database server"
  end

  newparam(:user) do
    desc "database user"
  end

  newparam(:password) do
    desc "database password"
  end

end

