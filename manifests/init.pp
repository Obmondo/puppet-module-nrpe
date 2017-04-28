# == Class: nrpe
#
# Full description of class nrpe here.
#
# === Parameters
#
# Document parameters here.
#
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# === Examples
#
#
# === Copyright
#
# Copyright 2013 Computer Action Team, unless otherwise noted.
#
class nrpe (
  Stdlib::AbsolutePath $config_file,
  Stdlib::AbsolutePath $include_dir,
  Stdlib::AbsolutePath $lib_dir,
  String $service_name,
  Variant[String, Array[String]] $packages,
  Eit_types::User $user,
  Eit_types::Group $group,
  Stdlib::AbsolutePath $pid_file,
  Array[Eit_types::IP] $allowed_hosts      = ['127.0.0.1'],
  Eit_types::IP $server_address            = '0.0.0.0',
  Integer[0, default] $command_timeout     = 60,
  Boolean $manage_package                  = true,
  Boolean $purge                           = true,
  Boolean $recurse                         = true,
  Boolean $dont_blame_nrpe                 = false,
  Boolean $allow_bash_command_substitution = false,
  Enum['daemon', 'syslog'] $log_facility   = 'syslog',
  Eit_types::Port $server_port             = 5666,
  Optional[String] $command_prefix         = undef,
  Boolean $debug                           = false,
  Integer[0, default] $connection_timeout  = 300,
  String $file_mode,
) {

  if $manage_package {
    ensure_packages($packages, {
      ensure   => installed,
    })
  }

  service { $service_name:
    ensure    => running,
    name      => $service_name,
    enable    => true,
    require   => Package[$packages],
    subscribe => File['nrpe_config'],
  }

  file { 'nrpe_config':
    name    => $config_file,
    content => epp('nrpe/nrpe.cfg.epp'),
    require => File['nrpe_include_dir'],
  }

  file { 'nrpe_include_dir':
    ensure  => directory,
    name    => $include_dir,
    purge   => $purge,
    recurse => $recurse,
    require => Package[$packages],
  }

}
