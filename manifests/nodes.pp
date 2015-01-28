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
$h_base = "/home/$h_user"
$h_master = 'hadoop-master'
$h_slaves = ['hadoop-slave3']
$h_hosts = "172.16.0.64 hadoop-master\n172.16.0.48 hadoop-slave1\n172.16.0.56 hadoop-slave2\n172.16.0.65 hadoop-slave3\n"

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
    hadoop_user => $h_user,
    hadoop_group => $h_group,
    hadoop_base => $h_base,
    scala_version => $sc_version,
    spark_version => $sp_version,
    spark_slaves => $sp_slaves,
  }
}

node /hadoop-slave\d*/ {
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
    hadoop_user => $h_user,
    hadoop_group => $h_group,
    hadoop_base => $h_base,
    scala_version => $sc_version,
    spark_version => $sp_version,
    spark_slaves => $sp_slaves,
  }
}
