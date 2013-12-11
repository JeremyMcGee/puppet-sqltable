
Puppet::Type.newtype(:sqltable) do

  @doc = "Manage key/value sql tables"

  ensurable

  newparam(:name, :namevar => true) do
    desc "resource name"
    validate do |value|
      components = value.split('.')
      if components.length == 3
        resource[:database] = components[0]
        resource[:key] = components[2]
      end
    end
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

  newparam(:database) do
    desc "database name"
  end

end

