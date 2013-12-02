# sqltable puppet module

Javier Palacios <javiplx@gmail.com>

## Overview

The purpose of this module is to manage simple sql tables that store configuration as name/value pairs. The use case is managing configuration of tomcat based applications, which commonly store configuration parameters on database instead of using a properties file.

## Limitations

The module only works with mysql, and only manages tables named *Configuration*.

## Resource definition

Resource description to create and delete a parameter looks like 

    sqltable { 'example.Configuration.parameter':
      ensure      => 'present',
      key         => 'parameter_name',
      value       => 'parameter-value',
      description => 'Description of the parameter',
      database    => 'example'
    }

    sqltable { 'example.Configuration.obsolete_parameter':
      ensure      => 'absent'
    }

If no database is specified, it is taken from the first part of the resource title.

## Resource discovering

The module is able to list existing resources, but only if locally run on the mysql server, and only searchs for tables named *Configuration*

