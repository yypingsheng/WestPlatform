class hadoop {

  require hadoop::params

  #Add Hadoop User and Group

  group { "${hadoop::params::hadoop_group}":
    ensure => present,
  }

  user { "${hadoop::params::hadoop_user}":
    ensure => present,
    home => "/home/${hadoop::params::hadoop_user}",
    managehome => true,
    require => Group["${hadoop::params::hadoop_group}"],
  }

  #Add "sudo" privilege for hadoop_user

  file { '/etc/sudoers.d/secure-hadoop-user':
    ensure => present,
    owner => 'root',
    group => 'root',
    alias => 'secure-hadoop-user',
    content => template('hadoop/sudoers/hadoop_sudoers.erb'),
  }

  #Add Nodes To Hosts, Make Local DNS

  file { '/etc/hosts':
    ensure => present,
    owner => 'root',
    group => 'root',
    mode => 0644,
    alias => 'etc-hosts',
    source => 'puppet:///modules/hadoop/hosts/hosts',
  }

  #Configure SSH, No Password Login

  file { "/home/${hadoop::params::hadoop_user}/.ssh/":
    ensure => "directory",
    owner => "${hadoop::params::hadoop_user}",
    group => "${hadoop::params::hadoop_group}",
    mode => 0700,
    alias => "${hadoop::params::hadoop_user}-ssh-dir",
  }

  file { "/home/${hadoop::params::hadoop_user}/.ssh/id_rsa.pub":
    ensure => present,
    owner => "${hadoop::params::hadoop_user}",
    group => "${hadoop::params::hadoop_group}",
    mode => 0644,
    source => 'puppet:///modules/hadoop/ssh/id_rsa.pub',
    require => File["${hadoop::params::hadoop_user}-ssh-dir"],
  }

  file { "/home/${hadoop::params::hadoop_user}/.ssh/id_rsa":
    ensure => present,
    owner => "${hadoop::params::hadoop_user}",
    group => "${hadoop::params::hadoop_group}",
    mode => 0600,
    source => 'puppet:///modules/hadoop/ssh/id_rsa',
    require => File["${hadoop::params::hadoop_user}-ssh-dir"],
  }

  file { "/home/${hadoop::params::hadoop_user}/.ssh/authorized_keys":
    ensure => present,
    owner => "${hadoop::params::hadoop_user}",
    group => "${hadoop::params::hadoop_group}",
    mode => 0644,
    source => 'puppet:///modules/hadoop/ssh/id_rsa.pub',
    require => File["${hadoop::params::hadoop_user}-ssh-dir"],
  }

  #Untar Hadoop Package

  file {"${hadoop::params::hadoop_base}":
    ensure => directory,
    owner => "${hadoop::params::hadoop_user}",
    group => "${hadoop::params::hadoop_group}",
    mode  => 0755,
    alias => 'hadoop-base',
  }

#  file { "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::hadoop_version}.tar.gz":
#    owner => "${hadoop::params::hadoop_user}",
#    group => "${hadoop::params::hadoop_group}",
#    mode => 0664,
#    source => "puppet:///modules/hadoop/hadoop-${hadoop::params::hadoop_version}.tar.gz",
#    alias => 'hadoop-source-tgz',
#    before => Exec['untar-hadoop'],
#    require => File['hadoop-base'],
#  }

  exec { "untar hadoop-${hadoop::params::hadoop_version}.tar.gz":
    command => "tar -zxf hadoop-${hadoop::params::hadoop_version}.tar.gz -C ${hadoop::params::hadoop_base}",
    cwd => '/home/ubuntu',
    creates => "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::hadoop_version}",
    alias => 'untar-hadoop',
    onlyif => "test 0 -eq $(ls -al ${hadoop::params::hadoop_base}/hadoop-${hadoop::params::hadoop_version} | grep -c bin)",
#    require => File['hadoop-source-tgz'],
    user => "${hadoop::params::hadoop_user}",
    before => File['hadoop-app-dir'],
    path => ['/bin', '/usr/bin', '/usr/sbin'],
  }

  file { "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::hadoop_version}":
     ensure => directory,
     mode => 0755,
     owner => "${hadoop::params::hadoop_user}",
     group => "${hadoop::params::hadoop_group}",
     alias => "hadoop-app-dir",
     require => Exec['untar-hadoop'],
  }

  #Set Hadoop Environment

  file { '/etc/profile.d/hadoop.sh':
    ensure => present,
    owner => 'root',
    group => 'root',
    alias => 'hadoop-profile',
    content => template('hadoop/environ/hadoop_profile.erb'),
  }

#  file { "/home/${hadoop::params::hadoop_user}/.bashrc":
#    ensure => present,
#    owner => "${hadoop::params::hadoop_user}",
#    group => "${hadoop::params::hadoop_user}",
#    alias => "${hadoop::params::hadoop_user}-bashrc",
#    content => template('hadoop/bashrc.erb'),
#    require => [ User["${hadoop::params::hadoop_user}"], File['hadoop-profile'] ],
#  }

  #Create Name、Data And Tmp Directory

  file { "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::hadoop_version}/dfs":
    ensure => directory,
    owner => "${hadoop::params::hadoop_user}",
    group => "${hadoop::params::hadoop_group}",
    alias => 'hadoop-dfs',
    require => File['hadoop-app-dir'],
  }

  file { "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::hadoop_version}/dfs/name":
    ensure => directory,
    owner => "${hadoop::params::hadoop_user}",
    group => "${hadoop::params::hadoop_group}",
    alias => 'hadoop-dfs-name',
    require => File['hadoop-dfs'],
  }

  file { "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::hadoop_version}/dfs/data":
    ensure => directory,
    owner => "${hadoop::params::hadoop_user}",
    group => "${hadoop::params::hadoop_group}",
    alias => 'hadoop-dfs-data',
    require => File['hadoop-dfs'],
  }

  file { "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::hadoop_version}/tmp":
    ensure => directory,
    owner => "${hadoop::params::hadoop_user}",
    group => "${hadoop::params::hadoop_group}",
    alias => 'hadoop-tmp',
    require => File['hadoop-app-dir'],
  }

  #Configure Hadoop

  file { "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::hadoop_version}/etc/hadoop/hadoop-env.sh":
    owner => "${hadoop::params::hadoop_user}",
    group => "${hadoop::params::hadoop_group}",
    mode => 0644,
    alias => 'hadoop-env-sh',
    content => template('hadoop/conf/hadoop-env.sh.erb'),
  }

  file { "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::hadoop_version}/etc/hadoop/yarn-env.sh":
    owner => "${hadoop::params::hadoop_user}",
    group => "${hadoop::params::hadoop_group}",
    mode => 0644,
    alias => 'yarn-env-sh',
    content => template('hadoop/conf/yarn-env.sh.erb'),
  }

  file { "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::hadoop_version}/etc/hadoop/master":
    owner => "${hadoop::params::hadoop_user}",
    group => "${hadoop::params::hadoop_group}",
    mode => 0644,
    alias => 'hadoop-master',
    content => template('hadoop/conf/master.erb'),
  }

  file { "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::hadoop_version}/etc/hadoop/slaves":
    owner => "${hadoop::params::hadoop_user}",
    group => "${hadoop::params::hadoop_group}",
    mode => 0644,
    alias => 'hadoop-slave',
    content => template('hadoop/conf/slaves.erb'),
  }

  file { "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::hadoop_version}/etc/hadoop/core-site.xml":
    owner => "${hadoop::params::hadoop_user}",
    group => "${hadoop::params::hadoop_group}",
    mode => 0644,
    alias => 'core-site-xml',
    content => template('hadoop/conf/core-site.xml.erb'),
  }

  file { "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::hadoop_version}/etc/hadoop/hdfs-site.xml":
    owner => "${hadoop::params::hadoop_user}",
    group => "${hadoop::params::hadoop_group}",
    mode => 0644,
    alias => 'hdfs-site-xml',
    content => template('hadoop/conf/hdfs-site.xml.erb'),
  }

  file { "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::hadoop_version}/etc/hadoop/mapred-site.xml":
    owner => "${hadoop::params::hadoop_user}",
    group => "${hadoop::params::hadoop_group}",
    mode => 0644,
    alias => 'mapred-site-xml',
    content => template('hadoop/conf/mapred-site.xml.erb'),
  }

  file { "${hadoop::params::hadoop_base}/hadoop-${hadoop::params::hadoop_version}/etc/hadoop/yarn-site.xml":
    owner => "${hadoop::params::hadoop_user}",
    group => "${hadoop::params::hadoop_group}",
    mode => 0644,
    alias => 'yarn-site-xml',
    content => template('hadoop/conf/yarn-site.xml.erb'),
  }
}
