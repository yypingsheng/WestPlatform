class ganglia::gweb {
  package {'php5':
    ensure => installed
  }
  package {'apache2':
    ensure => installed
  }
  #package {'rrdtool':
  #  ensure => installed
  #}
  package {'ganglia-webfrontend':
    ensure => installed
  }
  exec {'create softlink to /var/www/html':
    command => 'sudo ln -s /usr/share/ganglia-webfrontend /var/www/html/ganglia',
    path => ['/bin', '/usr/bin'],
    notify => Service['apache2']
  }
  service {'apache2':
    ensure => running
  }
}
