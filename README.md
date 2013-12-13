# sqltable puppet module

Javier Palacios <javiplx@gmail.com>

## Overview

The purpose of this module is to manage simple sql tables that store configuration as name/value pairs. The use case is managing configuration of tomcat based applications, which commonly store configuration parameters on database instead of using a properties file.

## Limitations

The module only works with mysql.

## Resource definition

If the title has the form **database.table.keyname**, it is parsed to fill other parameters, but only *table* has a default value (*Configuration*). An error is raised if the parameters are explicitly declared and do not match those coming from title.

Resource description to create and delete a parameter looks like 

    sqltable { 'parameter':
      ensure      => 'present',
      key         => 'parameter_name',
      value       => 'parameter-value',
      description => 'Description of the parameter',
      database    => 'example',
      table       => 'Config'
    }
    
    sqltable { 'example.Configuration.obsolete_parameter':
      ensure      => 'absent'
    }

There are also parameters to specify *host*, *user* and *password* required to connect to the database server.

## Resource discovering

The module is able to list existing resources, but only if locally run on the mysql server, and only searchs for tables named *Configuration*

