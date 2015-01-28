class hadoop ($hadoop_version, $hadoop_group, $hadoop_user, $hadoop_base, $hadoop_master, $hadoop_slaves, $hosts) {

  include java

  #Add Hadoop User and Group

  group { "$hadoop_group":
    ensure => present,
  }

  user { "$hadoop_user":
    ensure => present,
    home => "/home/$hadoop_user",
    managehome => true,
    require => Group["$hadoop_group"],
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

  file { "$hadoop_base/host.sh":
    ensure => present,
    owner => "$hadoop_user",
    group => "$hadoop_group",
    mode => 0744,
    alias => 'host-sh',
    source => 'puppet:///modules/hadoop/hosts/host.sh',
  }

  file { "$hadoop_base/hostlist":
    ensure => present,
    content => "$hosts",
    alias => 'hostlist',
    before => Exec['add-hosts'],
  }

  exec { 'add hosts':
    command => "bash $hadoop_base/host.sh",
    cwd => "$hadoop_base",
    alias => 'add-hosts',
    require => [ File['host-sh'], File['hostlist'] ],
    path => ['/bin', '/usr/bin', '/usr/sbin'],
  }

  #Configure SSH, No Password Login

  file { "/home/$hadoop_user/.ssh/":
    ensure => directory,
    owner => "$hadoop_user",
    group => "$hadoop_group",
    mode => 0700,
    alias => "$hadoop_user-ssh-dir",
  }

  file { "/home/$hadoop_user/.ssh/id_rsa.pub":
    ensure => present,
    owner => "$hadoop_user",
    group => "$hadoop_group",
    mode => 0644,
    source => 'puppet:///modules/hadoop/ssh/id_rsa.pub',
    require => File["$hadoop_user-ssh-dir"],
  }

  file { "/home/$hadoop_user/.ssh/id_rsa":
    ensure => present,
    owner => "$hadoop_user",
    group => "$hadoop_group",
    mode => 0600,
    source => 'puppet:///modules/hadoop/ssh/id_rsa',
    require => File["$hadoop_user-ssh-dir"],
  }

  file { "/home/$hadoop_user/.ssh/authorized_keys":
    ensure => present,
    owner => "$hadoop_user",
    group => "$hadoop_group",
    mode => 0644,
    source => 'puppet:///modules/hadoop/ssh/id_rsa.pub',
    require => File["$hadoop_user-ssh-dir"],
  }

  #Untar Hadoop Package

  file {"$hadoop_base":
    ensure => directory,
    owner => "$hadoop_user",
    group => "$hadoop_group",
    mode  => 0755,
    alias => 'hadoop-base',
  }

  file { "$hadoop_base/hadoop-$hadoop_version.tar.gz":
    owner => "$hadoop_user",
    group => "$hadoop_group",
    mode => 0664,
    source => "/home/ubuntu/hadoop-$hadoop_version.tar.gz",
    alias => 'hadoop-source-tgz',
    before => Exec['untar-hadoop'],
    require => File['hadoop-base'],
  }

  exec { "untar hadoop-$hadoop_version.tar.gz":
    command => "tar -zxf hadoop-$hadoop_version.tar.gz",
    cwd => "$hadoop_base",
    creates => "$hadoop_base/hadoop-$hadoop_version",
    alias => 'untar-hadoop',
    onlyif => "test 0 -eq $(ls -al $hadoop_base/hadoop-$hadoop_version | grep -c bin)",
    require => File['hadoop-source-tgz'],
    user => "$hadoop_user",
    before => File['hadoop-app-dir'],
    path => ['/bin', '/usr/bin', '/usr/sbin'],
  }

  file { "$hadoop_base/hadoop-$hadoop_version":
     ensure => directory,
     mode => 0755,
     owner => "$hadoop_user",
     group => "$hadoop_group",
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
    require => File['hadoop-app-dir'],
    notify => Exec['bash-source-hadoop'],
  }
  
  file { "$hadoop_base/source_hadoop.sh":
    ensure => present,
    owner => "$hadoop_user",
    group => "$hadoop_group",
    alias => 'source-hadoop',
    content => template('hadoop/environ/source_hadoop.sh.erb'),
    require => File['hadoop-base'],
  }

  exec { 'bash source_hadoop.sh':
    command => 'bash ./source_hadoop.sh',
    cwd => "$hadoop_base",
    alias => 'bash-source-hadoop',
    require => File['source-hadoop'],
    path => ['/bin', '/usr/bin', '/usr/sbin'],
  }

  #Create Name、Data And Tmp Directory

  file { "$hadoop_base/hadoop-$hadoop_version/dfs":
    ensure => directory,
    owner => "$hadoop_user",
    group => "$hadoop_group",
    alias => 'hadoop-dfs',
    require => File['hadoop-app-dir'],
  }

  file { "$hadoop_base/hadoop-$hadoop_version/dfs/name":
    ensure => directory,
    owner => "$hadoop_user",
    group => "$hadoop_group",
    alias => 'hadoop-dfs-name',
    require => File['hadoop-dfs'],
  }

  file { "$hadoop_base/hadoop-$hadoop_version/dfs/data":
    ensure => directory,
    owner => "$hadoop_user",
    group => "$hadoop_group",
    alias => 'hadoop-dfs-data',
    require => File['hadoop-dfs'],
  }

  file { "$hadoop_base/hadoop-$hadoop_version/tmp":
    ensure => directory,
    owner => "$hadoop_user",
    group => "$hadoop_group",
    alias => 'hadoop-tmp',
    require => File['hadoop-app-dir'],
  }

  #Configure Hadoop

  file { "$hadoop_base/hadoop-$hadoop_version/etc/hadoop/hadoop-env.sh":
    owner => "$hadoop_user",
    group => "$hadoop_group",
    mode => 0644,
    alias => 'hadoop-env-sh',
    content => template('hadoop/conf/hadoop-env.sh.erb'),
    require => File['hadoop-app-dir'],
  }

  file { "$hadoop_base/hadoop-$hadoop_version/etc/hadoop/yarn-env.sh":
    owner => "$hadoop_user",
    group => "$hadoop_group",
    mode => 0644,
    alias => 'yarn-env-sh',
    content => template('hadoop/conf/yarn-env.sh.erb'),
    require => File['hadoop-app-dir'],
  }

  file { "$hadoop_base/hadoop-$hadoop_version/etc/hadoop/master":
    owner => "$hadoop_user",
    group => "$hadoop_group",
    mode => 0644,
    alias => 'hadoop-master',
    content => template('hadoop/conf/master.erb'),
    require => File['hadoop-app-dir'],
  }

  file { "$hadoop_base/hadoop-$hadoop_version/etc/hadoop/slaves":
    owner => "$hadoop_user",
    group => "$hadoop_group",
    mode => 0644,
    alias => 'hadoop-slave',
    content => template('hadoop/conf/slaves.erb'),
    require => File['hadoop-app-dir'],
  }

  file { "$hadoop_base/hadoop-$hadoop_version/etc/hadoop/core-site.xml":
    owner => "$hadoop_user",
    group => "$hadoop_group",
    mode => 0644,
    alias => 'core-site-xml',
    content => template('hadoop/conf/core-site.xml.erb'),
    require => File['hadoop-app-dir'],
  }

  file { "$hadoop_base/hadoop-$hadoop_version/etc/hadoop/hdfs-site.xml":
    owner => "$hadoop_user",
    group => "$hadoop_group",
    mode => 0644,
    alias => 'hdfs-site-xml',
    content => template('hadoop/conf/hdfs-site.xml.erb'),
    require => File['hadoop-app-dir'],
  }

  file { "$hadoop_base/hadoop-$hadoop_version/etc/hadoop/mapred-site.xml":
    owner => "$hadoop_user",
    group => "$hadoop_group",
    mode => 0644,
    alias => 'mapred-site-xml',
    content => template('hadoop/conf/mapred-site.xml.erb'),
    require => File['hadoop-app-dir'],
  }

  file { "$hadoop_base/hadoop-$hadoop_version/etc/hadoop/yarn-site.xml":
    owner => "$hadoop_user",
    group => "$hadoop_group",
    mode => 0644,
    alias => 'yarn-site-xml',
    content => template('hadoop/conf/yarn-site.xml.erb'),
    require => File['hadoop-app-dir'],
  }
}
