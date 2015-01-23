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

node 'hadoop-master' {

    include java
    include java::params
    include hadoop
    include hadoop::params
#    include hadoop::cluster

}

node 'hadoop-slave1' {

    include java
    include java::params
    include hadoop
    include hadoop::params

}
