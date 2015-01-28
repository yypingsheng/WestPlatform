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

#hadoop params
$h_version = '2.2.0'
$h_group = 'hadoop'
$h_user = 'hadoop'
$h_base = "/home/$user"
$h_master = 'hadoop-master'
$h_slaves = ['hadoop-slave1', 'hadoop-slave2']
$h_hosts = "192.168.28.111 hadoop-master\n192.168.28.112 hadoop-slave1\n192.168.28.114 hadoop-slave2\n"

#spark params
$sc_version = '2.10.4'
$sp_version = '1.0.0-bin-hadoop2'
$sp_slaves = $h_slaves

node 'hadoop-master' {
  class { 'hadoop':
    hadoop_version => $h_version,
    hadoop_group => $h_group,
    hadoop_user => $h_user,
    hadoop_base => $h_base,
    hadoop_master => $h_master,
    hadoop_slaves => $h_slaves,
    hosts => $h_hosts,    
  }

  class { 'spark':
    scala_version => $sc_version,
    spark_version => $sp_version,
    spark_slaves => $sp_slaves,
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
    hosts => $h_hosts,
  }

  class { 'spark':
    scala_version => $sc_version,
    spark_version => $sp_version,
    spark_slaves => $sp_slaves,
  }
}
