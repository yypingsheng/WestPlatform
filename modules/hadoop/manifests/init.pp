class hadoop {

  require hadoop::params

  user { '${hadoop::params::hadoop_user}':
    ensure => present,
  }

  group { '${hadoop::params::hadoop_group}':
    ensure => present,
  }

  file { '/etc/profile.d/hadoop.sh':
    ensure => present,
    content => template('hadoop/bash_profile.erb'),
  }

  file { '/home/ubuntu/hadoop-2.2.0/dfs/name':
    ensure => directory,
    ower => '${hadoop::params::hadoop_user}',
    group => '${hadoop::params::hadoop_group}',
    require => [ User['${hadoop::parama::hadoop_user}'], Group['${hadoop::params::hadoop_group}'],
  }

  file { '/home/ubuntu/hadoop-2.2.0/dfs/data':
    ensure => directory,
    ower => '${hadoop::params::hadoop_user}',
    group => '${hadoop::params::hadoop_group}',
    require => [ User['${hadoop::parama::hadoop_user}'], Group['${hadoop::params::hadoop_group}'],
  }

  
  file { '/home/ubuntu/hadoop-2.2.0/tmp':
    ensure => directory,
    ower => '${hadoop::params::hadoop_user}',
    group => '${hadoop::params::hadoop_group}',
    require => [ User['${hadoop::parama::hadoop_user}'], Group['${hadoop::params::hadoop_group}'],
  }

  file { '/home/ubuntu/hadoop-2.2.0/etc/hadoop/hadoop-env.sh':
    ower => '${hadoop::params:hadoop_user}',
    group => '${hadoop::params:hadoop_group}',
    mode => 0664,
    alias => 'hadoop-env-sh',
    content => template('hadoop/hadoop-env.sh.erb'),
  }

  file { '/home/ubuntu/hadoop-2.2.0/etc/hadoop/yarn-env.sh':
    ower => '${hadoop::params:hadoop_user}',
    group => '${hadoop::params:hadoop_group}',
    mode => 0664,
    alias => 'yarn-env-sh',
    content => template('hadoop/yarn-env.sh.erb'),
  }

  file { '/home/ubuntu/hadoop-2.2.0/etc/hadoop/master':
    ower => '${hadoop::params:hadoop_user}',
    group => '${hadoop::params:hadoop_group}',
    mode => 0664,
    alias => 'hadoop-master',
    content => template('hadoop/master.erb'),
  }

  file { '/home/ubuntu/hadoop-2.2.0/etc/hadoop/slaves':
    ower => '${hadoop::params:hadoop_user}',
    group => '${hadoop::params:hadoop_group}',
    mode => 0664,
    alias => 'hadoop-slave',
    content => template('hadoop/slaves.erb'),
  }

  file { '/home/ubuntu/hadoop-2.2.0/etc/hadoop/core-site.xml':
    ower => '${hadoop::params:hadoop_user}',
    group => '${hadoop::params:hadoop_group}',
    mode => 0664,
    alias => 'core-site-xml',
    content => template('hadoop/core-site.xml.erb'),
  }

  file { '/home/ubuntu/hadoop-2.2.0/etc/hadoop/hdfs-site.xml':
    ower => '${hadoop::params:hadoop_user}',
    group => '${hadoop::params:hadoop_group}',
    mode => 0664,
    alias => 'hdfs-site-xml',
    content => template('hadoop/hdfs-site.xml.erb'),
  }

  file { '/home/ubuntu/hadoop-2.2.0/etc/hadoop/mapred-site.xml':
    ower => '${hadoop::params:hadoop_user}',
    group => '${hadoop::params:hadoop_group}',
    mode => 0664,
    alias => 'mapred-site-xml',
    content => template('hadoop/mapred-site.xml.erb'),
  }

  file { '/home/ubuntu/hadoop-2.2.0/etc/hadoop/yarn-site.xml':
    ower => '${hadoop::params:hadoop_user}',
    group => '${hadoop::params:hadoop_group}',
    mode => 0664,
    alias => 'yarn-site-xml',
    content => template('hadoop/yarn-site.xml.erb'),
  }
}

