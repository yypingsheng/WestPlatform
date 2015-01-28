class spark ($hadoop_user, $hadoop_group, $hadoop_base, $scala_version, $spark_version, $spark_slaves) {
  #require hadoop

  #scala package

  file { "$hadoop_base/scala-$scala_version.tgz":
    ensure => present,
    owner => "$hadoop_user",
    group => "$hadoop_group",
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
    subscribe => File['scala-source-tgz'],
    before => File['scala-app-dir'],
    path => ['/bin', '/usr/bin', '/usr/sbin'],
  }

  #scala app directory

  file { "$hadoop_base/scala-$scala_version":
    ensure => directory,
    owner => "$hadoop_user",
    group => "$hadoop_group",
    mode => 0755,
    alias => 'scala-app-dir',
    require => Exec['untar-scala'],
  }

  #set scala environment

  file { '/etc/profile.d/scala.sh':
    ensure => present,
    owner => 'root',
    group => 'root',
    alias => 'scala-profile',
    content => template('spark/environ/scala_profile.erb'),
    require => File['scala-app-dir'],
    notify => Exec['bash-source-scala'],
  }

  file { "$hadoop_base/source_scala.sh":
    ensure => present,
    owner => "$hadoop_user",
    group => "$hadoop_group",
    alias => 'source-scala',
    content => template('spark/environ/source_scala.sh.erb'),
    require => File['hadoop-base'],
  }

  exec { 'bash source_scala.sh':
    command => 'bash ./source_scala.sh',
    cwd => "$hadoop_base",
    alias => 'bash-source-scala',
    require => File['source-scala'],
    path => ['/bin', '/usr/bin', '/usr/sbin'],
  }

  #spark package

  file { "$hadoop_base/spark-$spark_version.tgz":
    ensure => present,
    owner => "$hadoop_user",
    group => "$hadoop_group",
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
    subscribe => File['spark-source-tgz'],
    before => File['spark-app-dir'],
    path => ['/bin', '/usr/bin', '/usr/sbin'],
  }

  #spark app directory
  
  file { "$hadoop_base/spark-$spark_version":
    ensure => directory,
    owner => "$hadoop_user",
    group => "$hadoop_group",
    mode => 0755,
    alias => 'spark-app-dir',
    require => Exec['untar-spark'],
  }
 
  #set spark environment

  file { '/etc/profile.d/spark.sh':
    ensure => present,
    owner => 'root',
    group => 'root',
    alias => 'spark-profile',
    content => template('spark/environ/spark_profile.erb'),
    require => File['spark-app-dir'],
    notify => Exec['bash-source-spark'],
  }

  file { "$hadoop_base/source_spark.sh":
    ensure => present,
    owner => "$hadoop_user",
    group => "$hadoop_group",
    alias => 'source-spark',
    content => template('spark/environ/source_spark.sh.erb'),
    require => File['hadoop-base'],
  }

  exec { 'bash source_spark.sh':
    command => 'bash ./source_spark.sh',
    cwd => "$hadoop_base",
    alias => 'bash-source-spark',
    require => File['source-spark'],
    path => ['/bin', '/usr/bin', '/usr/sbin'],
  }

  #confige spark

  file { "$hadoop_base/spark-$spark_version/conf/spark-env.sh":
    owner => "$hadoop_user",
    group => "$hadoop_group",
    mode => 0644,
    alias => 'spark-env-sh',
    content => template('spark/conf/spark-env.sh.erb'),
    require => File['spark-app-dir'],
  }

  file { "$hadoop_base/spark-$spark_version/conf/slaves":
    owner => "$hadoop_user",
    group => "$hadoop_group",
    mode => 0644,
    alias => 'spark-slave',
    content => template('spark/conf/slaves.erb'),
    require => File['spark-app-dir'],
  }

  exec { 'cp log4j.properties.template log4j.properties':
    command => 'cp log4j.properties.template log4j.properties',
    cwd => "$hadoop_base/spark-$spark_version/conf",
    creates => "$hadoop_base/spark-$spark_version/conf/log4j.properties",
    alias => 'cp-log4j',
    require => File['spark-app-dir'],
    path => ['/bin', '/usr/bin', '/usr/sbin'],
  }

  file { "$hadoop_base/spark-$spark_version/conf/log4j.properties":
    ensure => present,
    owner => "$hadoop_user",
    group => "$hadoop_group",
    mode => 0644,
    require => Exec['cp-log4j'],
  }
}
