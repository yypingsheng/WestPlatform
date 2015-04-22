class hadoop::cluster ($hadoop_user, $hadoop_base, $hadoop_version) {

  require hadoop

  exec { 'format namenode':
    command => './hadoop namenode -format',
    user => "$hadoop_user",
    cwd => "$hadoop_base/hadoop-$hadoop_version/bin",
    creates => "$hadoop_base/hadoop-$hadoop_version/tmp/dfs/name/current/VERSION",
    alias => 'format-hdfs',
    path => ['/bin', '/usr/bin', "$hadoop_base/hadoop-$hadoop_version/bin"],
    require => File['hadoop-master'],
    before => Exec['start-all'],
  }

  exec { 'start all services':
    command => './start-all.sh',
    user => "$hadoop_user",
    cwd => "$hadoop_base/hadoop-$hadoop_version/sbin",
    alias => 'start-all',
    path => ['/bin', 'sbin', '/usr/bin', '/usr/sbin', "$hadoop_base/hadoop-$hadoop_version/sbin"],
    require => Exec['format-hdfs'],
  }

}
