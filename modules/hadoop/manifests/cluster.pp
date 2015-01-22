class hadoop::cluster {

  require hadoop::params
  require hadoop

  exec { 'format namenode':
    command => './hdfs namenode -format',
    cwd => "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::hadoop_version}/bin",
    creates => "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::hadoop_version}/tmp/dfs/name/current/VERSION",
    alias => 'format-hdfs',
    path => ['/bin', 'sbin', '/usr/bin', '/usr/sbin', "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::hadoop_version}/bin"],
    require => File['hadoop-master'],
#   before => Exec['start-all'],
  }

#  exec { 'start all services':
#    command => './start-all.sh',
#    cwd => '${hadoop::params::hadoop_base}/hadoop-${hadoop::params::hadoop_version}/sbin',
#    alias => 'start-all',
#    path => ['/bin', 'sbin', '/usr/bin', '/usr/sbin', '${hadoop::params::hadoop_base}/hadoop-${hadoop::params::hadoop_version}/sbin'],
#  }
}
