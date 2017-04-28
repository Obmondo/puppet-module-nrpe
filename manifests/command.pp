#
define nrpe::command (
  $command,
  Enum[present, absent] $ensure       = present,
  $sudo         = false,
  $sudo_user    = 'root',
) {
  $_include_dir = lookup('nrpe::include_dir')

  file { "${_include_dir}/${title}.cfg":
    ensure  => $ensure,
    content => template('nrpe/command.cfg.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package[lookup('nrpe::packages')],
    notify  => Service[lookup('nrpe::service_name')],
  }

}
