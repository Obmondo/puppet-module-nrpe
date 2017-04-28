#
define nrpe::plugin (
  Enum[present, absent] $ensure       = present,
  $content      = undef,
  $source       = undef,
) {
  $_lib_dir = lookup('nrpe::lib_dir')

  $_packages = lookup('nrpe::packages')
  # notify { "woop !installing these packages ${_packages}": }

  file { "${_lib_dir}/${title}":
    ensure  => $ensure,
    content => $content,
    source  => $source,
    owner   => 'root',
    group   => 'root',
    mode    => lookup('nrpe::file_mode'),
    require => Package[lookup('nrpe::packages')],
  }
}
