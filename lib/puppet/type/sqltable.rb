
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

end

