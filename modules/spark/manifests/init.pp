class spark ($scala_version, $spark_version, $spark_slaves) {
  include hadoop

  #scala package

  file { "$hadoop_base/scala-$scala_version.tgz":
    ensure => present,
    user => "$hadoop_user"
    group => "$haoop_group",
    mode => 0664,
    source => "/home/ubuntu/scala-$scala_version.tgz",
    alias => 'scala-source-tgz',
    require => File['hadoop-base'],
    before => Exec['untar-scala'],
  }

  #untar scala package

  exec { "untar scala-$scala_version.tgz":
    command => "tar -zxf scala-$scala_version.tgz",
    cwd => "$hadoop_base",
    creates => "$hadoop_base/scala-$scala_version",
    alias => 'untar-scala',
    require => File['scala-source-tgz'],
    user => "$hadoop_user",
    refreshonly => true,
    subcrible => File['scala-source-tgz'],
    before => File['scala-app-dir'],
    path => ['/bin', '/usr/bin', '/usr/sbin'],
  }

  #scala app directory

  file { "$hadoop_base/scala-$scala_version":
    ensure => directory,
    user => "$hadoop_user",
    group => "$hadoop_group",
    mode => 0755,
    alias => 'scala-add-dir',
    require => Exec['untar-scala'],
  }

  #set scala environment

  file { '/etc/profile.d/scala.sh':
    ensure => present,
    owner => 'root',
    group => 'root',
    alias => 'scala-profile',
    content => template('spark/environ/scala_profile.erb'),
    notify => Exec['source-scala-profile'],
  }

  exec { 'source scala profile':
    command => 'source /etc/profile',
    cwd => '/etc',
    alais => 'source-scala-profile',
    path => ['/bin', '/usr/bin', '/usr/sbin'],
  }

  #spark package

  file { "$hadoop_base/spark-$spark_version.tgz":
    ensure => present,
    user => "$hadoop_user"
    group => "$haoop_group",
    mode => 0664,
    source => "/home/ubuntu/spark-$spark_version.tgz",
    alias => 'spark-source-tgz',
    require => File['hadoop-base'],
    before => Exec['untar-spark'],
  }

  #untar spark package

  exec { "untar spark-$spark_version.tgz":
    command => "tar -zxf spark-$spark_version.tgz",
    cwd => "$hadoop_base",
    creates => "$hadoop_base/spark-$spark_version",
    alias => 'untar-spark',
    require => File['spark-source-tgz'],
    user => "$hadoop_user",
    refreshonly => true,
    subcrible => File['spark-source-tgz'],
    before => File['spark-app-dir'],
    path => ['/bin', '/usr/bin', '/usr/sbin'],
  }

  #spark app directory
  
  file { "$hadoop_base/spark-$spark_version":
    ensure => directory,
    user => "$hadoop_user",
    group => "$hadoop_group",
    mode => 0755,
    alias => 'spark-add-dir',
    require => Exec['untar-spark'],
  }
 
  #set spark environment

  file { '/etc/profile.d/spark.sh':
    ensure => present,
    owner => 'root',
    group => 'root',
    alias => 'spark-profile',
    content => template('spark/environ/spark_profile.erb'),
    notify => Exec['source-spark-profile'],
  }

  exec { 'source spark profile':
    command => 'source /etc/profile',
    cwd => '/etc',
    alais => 'source-spark-profile',
    path => ['/bin', '/usr/bin', '/usr/sbin'],
  }

  #confige spark

  file { "$hadoop_base/spark-$spark_version/conf/spark-env.sh":
    owner => "$hadoop_user",
    group => "$hadoop_group",
    mode => 0644,
    alias => 'spark-env-sh',
    content => template('spark/conf/spark-env.sh.erb'),
  }

  file { "$hadoop_base/spark-$spark_version/conf/slaves":
    owner => "$hadoop_user",
    group => "$hadoop_group",
    mode => 0644,
    alias => 'spark-slave',
    content => template('spark/conf/slaves.erb'),
  }

  exec { 'cp log4j.properties.template log4j.properties':
    command => 'cp log4j.properties.template log4j.properties',
    cwd => "$hadoop_base/spark-$spark_version/conf",
    creates => "$hadoop_base/spark-$spark_version/conf/log4j.properties",
    path => ['/bin', '/usr/bin', '/usr/sbin'],
  }
}
