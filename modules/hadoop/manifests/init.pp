class hadoop {

  require hadoop::params

  user { "${hadoop::params::hadoop_user}":
    ensure => present,
  }

  group { "${hadoop::params::hadoop_group}":
    ensure => present,
  } 

#  file { '/etc/profile.d/hadoop.sh':
#    ensure => present,
#    owner => 'root',
#    group => 'root',
#    alias => 'hadoop-profile',
#    content => template('hadoop/bash_profile.erb'),
#  }

#  file { '/home/ubuntu/.bashrc':
#    ensure => present,
#    owner => 'ubuntu',
#    group => 'ubuntu',
#    alias => 'ubuntu-bashrc',
#    content => template('hadoop/bashrc.erb'),
#    require => [ User["${hadoop::params::hadoop_user}"], File['hadoop-profile'] ],
#  }
 
  file { '/home/ubuntu/hadoop-2.2.0/dfs':
    ensure => directory,
    owner => "${hadoop::params::hadoop_user}",
    group => "${hadoop::params::hadoop_group}",
    alias => 'hadoop-dfs',
    require => [ User["${hadoop::params::hadoop_user}"], Group["${hadoop::params::hadoop_group}"] ],
  }

  file { '/home/ubuntu/hadoop-2.2.0/dfs/name':
    ensure => directory,
    owner => "${hadoop::params::hadoop_user}",
    group => "${hadoop::params::hadoop_group}",
    alias => 'hadoop-dfs-name',
    require => [ User["${hadoop::params::hadoop_user}"], Group["${hadoop::params::hadoop_group}"], File['hadoop-dfs'] ],
  }

  file { '/home/ubuntu/hadoop-2.2.0/dfs/data':
    ensure => directory,
    owner => "${hadoop::params::hadoop_user}",
    group => "${hadoop::params::hadoop_group}",
    alias => 'hadoop-dfs-data',
    require => [ User["${hadoop::params::hadoop_user}"], Group["${hadoop::params::hadoop_group}"], File['hadoop-dfs'] ],
  }

  
  file { '/home/ubuntu/hadoop-2.2.0/tmp':
    ensure => directory,
    owner => "${hadoop::params::hadoop_user}",
    group => "${hadoop::params::hadoop_group}",
    alias => 'hadoop-tmp',
    require => [ User["${hadoop::params::hadoop_user}"], Group["${hadoop::params::hadoop_group}"] ],
  }

  file { '/home/ubuntu/hadoop-2.2.0/etc/hadoop/hadoop-env.sh':
    owner => "${hadoop::params::hadoop_user}",
    group => "${hadoop::params::hadoop_group}",
    mode => 0664,
    alias => 'hadoop-env-sh',
    content => template('hadoop/hadoop-env.sh.erb'),
  }

  file { '/home/ubuntu/hadoop-2.2.0/etc/hadoop/yarn-env.sh':
    owner => "${hadoop::params::hadoop_user}",
    group => "${hadoop::params::hadoop_group}",
    mode => 0664,
    alias => 'yarn-env-sh',
    content => template('hadoop/yarn-env.sh.erb'),
  }

  file { '/home/ubuntu/hadoop-2.2.0/etc/hadoop/master':
    owner => "${hadoop::params::hadoop_user}",
    group => "${hadoop::params::hadoop_group}",
    mode => 0664,
    alias => 'hadoop-master',
    content => template('hadoop/master.erb'),
  }

  file { '/home/ubuntu/hadoop-2.2.0/etc/hadoop/slaves':
    owner => "${hadoop::params::hadoop_user}",
    group => "${hadoop::params::hadoop_group}",
    mode => 0664,
    alias => 'hadoop-slave',
    content => template('hadoop/slaves.erb'),
  }

  file { '/home/ubuntu/hadoop-2.2.0/etc/hadoop/core-site.xml':
    owner => "${hadoop::params::hadoop_user}",
    group => "${hadoop::params::hadoop_group}",
    mode => 0664,
    alias => 'core-site-xml',
    content => template('hadoop/core-site.xml.erb'),
  }

  file { '/home/ubuntu/hadoop-2.2.0/etc/hadoop/hdfs-site.xml':
    owner => "${hadoop::params::hadoop_user}",
    group => "${hadoop::params::hadoop_group}",
    mode => 0664,
    alias => 'hdfs-site-xml',
    content => template('hadoop/hdfs-site.xml.erb'),
  }

  file { '/home/ubuntu/hadoop-2.2.0/etc/hadoop/mapred-site.xml':
    owner => "${hadoop::params::hadoop_user}",
    group => "${hadoop::params::hadoop_group}",
    mode => 0664,
    alias => 'mapred-site-xml',
    content => template('hadoop/mapred-site.xml.erb'),
  }

  file { '/home/ubuntu/hadoop-2.2.0/etc/hadoop/yarn-site.xml':
    owner => "${hadoop::params::hadoop_user}",
    group => "${hadoop::params::hadoop_group}",
    mode => 0664,
    alias => 'yarn-site-xml',
    content => template('hadoop/yarn-site.xml.erb'),
  }
}

