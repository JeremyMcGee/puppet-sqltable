
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

end

