node 'tian-PC' {
    $site_domain = 'tian-PC.example.com'
    
    nginx::website { 'my-pc':
        site_domain => 'tian-PC.example.com',
    }
    
    exec { 'retrieve home page':
        command => "wget -o stdout http://$site_domain > /dev/null",
        path => ['/bin', '/usr/bin'],
    }

    class { 'ntp':
        server => 'us.pool.ntp.org',
    }
}

$version = '2.2.0'
$group = 'hadoop'
$user = 'hadoop'
$base = "/home/$user"
$master = 'hadoop-master'
$slaves = ['hadoop-slave1', 'hadoop-slave2']

node 'hadoop-master' {
  class { 'hadoop':
    hadoop_version => $version,
    hadoop_group => $group,
    hadoop_user => $user,
    hadoop_base => $base,
    hadoop_master => $master,
    hadoop_slaves => $slaves,    
  }
}

node /hadoop-slave\d*/ {
  class { 'hadoop':
    hadoop_version => $version,
    hadoop_group => $group,
    hadoop_user => $user,
    hadoop_base => $base,
    hadoop_master => $master,
    hadoop_slaves => $slaves,
  }
}
