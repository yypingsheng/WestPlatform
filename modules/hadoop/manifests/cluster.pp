class hadoop::cluster {
  
  # require hadoop::params
  require hadoop

  exec { 'Format namenode':
    command => './hdfs namenode -format',
    cwd => '/home/ubuntu/hadoop-2.2.0/bin',
    creates => '/home/ubuntu/hadoop-2.2.0/tmp/dfs/name/current/VERSION',
    alias => 'format-hdfs',
    path => ['/bin', '/usr/bin', '/home/ubuntu/hadoop-2.2.0/bin'],
    require => File['hadoop-master'],
    before => Exec['start-all'],
  }

  exec { 'Start all services':
    command => './start-all.sh',
    cwd => '/home/ubuntu/hadoop-2.2.0/sbin',
    alias => 'start-all',
    path => ['/bin', '/usr/bin', '/home/ubuntu/hadoop-2.2.0/sbin'],
  } 
}
