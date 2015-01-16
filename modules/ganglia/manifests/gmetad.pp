class ganglia::gmetad {
  package {'rrdtool':
    ensure => installed
  }
  package {'gmetad':
    ensure => installed
  }
  file {'/etc/ganglia/gmetad.conf':
    content => template('ganglia/gmetad.conf.erb'),
    notify => Service['gmetad']
  }
  service {'gmetad':
    ensure => running
  }
}
