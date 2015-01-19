class hadoop::params {
  
  $hadoop_user = $::hostname ? {
    default => 'ubuntu',
  }
 
  $hadoop_group = $::hostname ? {
    default => 'ubuntu',
  }
}
