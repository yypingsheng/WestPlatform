# Manage nginx webserver
class nginx {
    package {
        'nginx': ensure => installed,
    }
    
    file { '/etc/nginx/sites-enabled/default':
        ensure => absent,
    }

    file { '/var/www': 
        source => 'puppet:///modules/nginx/www',
        recurse => true,
    }

    service { 'nginx':
        require => Package['nginx'], 
        ensure => running,
    }
}
