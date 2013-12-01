
Puppet::Type.type(:sqltable).provide(:sqltable) do

  def exists?
    !(resource[:ensure] == :absent or resource[:ensure].nil?)
  end

  def key
    resource[:key]
  end

  def value
    resource[:value]
  end

  def description
    resource[:description]
  end

end
