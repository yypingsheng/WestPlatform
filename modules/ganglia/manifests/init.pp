class ganglia($mod='0'){
  case $mod{
    0:{
      include ganglia::gmond
    }
    1:{
      include ganglia::gmond
      include ganglia::gmetad
      include ganglia::gweb
    }
  }
}
