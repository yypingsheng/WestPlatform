class hadoop::params {


  $hadoop_version = $::hostname ? {
    default => '2.2.0',
  }

  $hadoop_user = $::hostname ? {
    default => 'hadoop',
  }

  $hadoop_group = $::hostname ? {
    default => 'hadoop',
  }

  $hadoop_master = $::hostname ? {
    default => 'hadoop-master',
  }

  $hadoop_slave = $::hostname ? {
    default => ['hadoop-slave1'],
  }

  $hadoop_base = $::hostname ? {
    default => "/home/${hadoop::params::hadoop_user}",
  }

}
