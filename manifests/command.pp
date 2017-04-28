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
    content => epp('nrpe/command.cfg.epp', {
      command   => $command,
      sudo      => $sudo,
      sudo_user => $sudo_user,
      name      => $name,
    }),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package[lookup('nrpe::packages')],
    notify  => Service[lookup('nrpe::service_name')],
  }

}
