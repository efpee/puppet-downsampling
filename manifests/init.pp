# == Class: emsa_downsampling
#
# This module installs the EMSA down sampling component to a WebLogic 
# server/cluster.
# It will generate a deployment script to create all required JMS resources, 
# deploy the ear package and install the Hazelcast in memory grid.
#
# Before executing the model the following deliverables need to be present on 
# the VM where down sampling module is being installed:
# $root_dir/artifacts/position-downsampling-ear-$version.ear
# $root_dir/artifacts/position-downsampling-model.jar
#
# External libraries (commons-lang, hazelcast and jcache) will be downloaded 
# from the internet, so connections to the internet need to be allowed.
# 
# === Parameters
#
# Document parameters here.
#
# [*version*]
#   Version of downsampling package to be deployed. 
#   This is expected to be part of the package name. 
#   Default: 1.1.3
#
# [*previous_version*]
#   Version of downsampling to be undeployed, if any.
#
# [*root_dir*]            
#   Base directory under which deployables and resources will be created.
#   Default: /downsampling
#
# [*java_home*]
#   Location of the java executable.
#   Default: /usr/bin/java
# 
# [*hzl_version*]
#   Version of hazelcast in memory store to be installed.
#   Default: 3.4.2
#
# [*hzl_cluster*]
#   Name of the hazelcast cluster.
#   Default: star
#
# [*hzl_pass*]
#   Password to be used to access the hazelcast cluster.
#
# [*hzl_min_heap*]
#   Minimal heap size for the hazelcast process.
#
# [*hzl_max_heap*]
#   Maximal heap size for the hazelcast process.
#
# [*hzl_man_center_enabled*]
#   Enable the hazelcast management center. This is feature is limited to 
#   commercially licensed installations or the clusters with maximum 2 nodes.
#   Default: false
#
# [*hzl_man_center_uri*]
#   URL used to access the hazelcast management center, if enabled.
#   Default: http://localhost:8080/mancenter
#
# [*hzl_multicast_enabled*]
#   Use multicast for communication between hazelcast cluster nodes.
#   Default: false
#
# [*hzl_multicast_group*]
#   Address to be used for multicast communication, if used.
#   Default: 224.2.2.3
#
# [*hzl_multicast_port*]
#   Port to be used when using multicast for cluster communication.
#   Default: 54327
#
# [*hzl_tcp_enabled*]
#   Use unicast for communication between hazelcast cluster nodes.
#   Default: true
#
# [*hzl_tcp_server_ips*]
#   IP addresses of the cluster nodes when using unicast.
#
# [*hzl_aws_enabled*]
#   Enable specific communication protocol for deployment on amazon cloud (AWS).
#   Default: false
#
# [hzl_aws_access_key*]
#   Access key to be used when deploying on AWS.
#
# [*hzl_aws_secret_key*]
#   Secret to be used when deloying on AWS.
#
# [*hzl_aws_host_header*]
#   Host header for deployment on AWS.
#   default: ec2.amazonaws.com
#
# [*hzl_aws_region*]
#   AWS region to be used.
#   
# [*commons_lang_version*]
#   Version of the Apache commons-lang library to be used.
#   Default: 3.3.2'
#
# [*jcache_version*]
#   Version of the jcache interfaces to be used.
#   Default: 1.0.0
#
# [*wls_user*]
#   Weblogic user to be used for connecting to the WLS administration server
#   during deployment.
#
# [*wls_pass*]
#   Password for the weblogic user used during deployment. If left empty,
#   it needs to be set in the connect.py script before running the deployment.
#
# [*wls_admin_url*]
#   URL to connect to the WLS administration server.
#
# [*wls_domain_dir*]
#   Location of the WLS domain.
#   Default: /wl_domains/imdate/
# 
# [*wls_app_cluster*]
#   Name of the application server cluster.
#   Default: imdateAppCluster
# 
# [*wls_app_servers*]
#   Array of the the WLS application server names (i.e. the members of 
#   $wls_app_cluster).
#   Default: ['imdateAppSrv1', 'imdateAppSrv2']
#
# [*wls_jms_cluster*]
#   Name of the application server cluster.
#   Default: imdateJmsCluster
# 
# [*wls_jms_servers*]
#   Array of the the WLS jms server names (i.e. the members of $wls_jms_cluster).
#   Default: ['imdateJmsSrv1', 'imdateJmsSrv2', 'imdateJmsSrv3', 'imdateJmsSrv4']
#
# [*deploy_on_wls*]
#   Execute the weblogic deployment script (creates JMS resources and deploys 
#   the down sampling application). This should be done only once per 
#   administration server.
#   Default: false
#
# [*jms_input_type*]
#   Type of the JMS resource that the down sampling component will be reading 
#   from. This can be either: javax.jms.Queue or javax.jms.Topic
#   Default: javax.jms.Queue
#
# [*jms_input_connection_factory*]
#   JMS connection factory to be used to access the JMS resource down sampling 
#   component will be reading from.
#   Default: jms.star.DownSampling.ConnectionFactory
#
# [*jms_input_destination*]
#   JNDI name of the JMS resource down sampling will be reading from.
#   Default: jms.star.DownSampling.PositionQueue
#
# [*jms_output_type*]
#   Type of the JMS resource that the down sampling component will be sending 
#   messages to. This can be either: javax.jms.Queue or javax.jms.Topic
#   Default: javax.jms.Queue
#
# [*jms_output_connection_factory*]
#   JMS connection factory to be used to access the JMS resource down sampling 
#   component will be sending messages to.
#   Default: jms.star.DownSampling.IMDatEConnectionFactoryy
#
# [*jms_output_destination*]
#   JNDI name of the JMS resource down sampling will be sending output to.
#   Default: jms.star.DownSampling.imdate.OutputQueue
#
# [*max_future*]
#   Positions with a timestamp greater than current time + max_future seconds 
#   will be discarded.
#   Default: 3600
#
# [*cache_eviction*]
#   Time in seconds before entries can be deleted from the cache.
#   default: 7200,
# 
# [*sat_ais_default*]
#   Default down sampling window for Sat-AIS messages.
#   Default: 60
#
# [*t_ais_default*]
#   Default down sampling window for T-AIS messages.
#   Default: 360
#
# [*oinstall_gid*]
#   GID to be used when/if creating the oinstall group.
#   Default: 115
#
# [*oracle_gid*]
#   GID to be used when/if creating the oracle user.
#   Default: 115
#
#
# === Variables
#
#
# === Examples
#
#  class { 'emsa_downsampling':
#    version            => '1.1.3',
#    hzl_version         => '3.4.2',
#    hzl_tcp_server_ips  => ['127.0.0.1'],
#    hzl_pass            => 'darkstar-t',
#    wls_user            => 'weblogic',
#    wls_pass            => 'weblogic1',
#    wls_admin_url      => 't3://localhost:7002',
#    wls_domain_dir      => '/home/vagrant/Oracle/user_domains/imdate/',
#    wls_app_cluster    => 'ImdAppSrvCluster',
#    wls_app_servers    => ['IMDAppSrv1', 'IMDAppSrv2'],
#    wls_jms_cluster    => 'ImdJmsSrvCluster',
#    wls_jms_servers    => ['IMDJmsSrv1', 'IMDJmsSrv2'],  
#    deploy_on_wls      => true,
#    jms_input_type                => 'javax.jms.Topic',
#    jms_input_connection_factory  => 'imdate.ConnectionFactory',
#    jms_input_destination         => 'imdate.downsampled.topic',
#    jms_output_type               => 'not used?',
#    jms_output_connection_factory => 'imdate.ConnectionFactory',
#    jms_output_destination        => 'imdate.l1.downsampled.topic',
#    t_ais_default                 => 333,
#    sat_ais_default               => 66,
#  }
#
#
# === Authors
#
# Frank Premereur <frank.premereur@emsa.europa.eu>
#
# === Copyright
#
# Copyright 2016 European Maritime Safety Agency, unless otherwise noted.
#
class emsa_downsampling (
  $version                = '1.1.3',
  $previous_version       = '',
  $root_dir               = '/downsampling',
  $java_home              = '/usr/bin/java',
  $hzl_version            = '3.4.2',
  $hzl_cluster            = 'star',
  $hzl_pass               = '',
  $hzl_min_heap           = '',
  $hzl_max_heap           = '',
  $hzl_man_center_enabled = false,
  $hzl_man_center_uri     = 'http://localhost:8080/mancenter',
  $hzl_multicast_enabled  = false,
  $hzl_multicast_group    = '224.2.2.3',
  $hzl_multicast_port     = '54327',
  $hzl_tcp_enabled        = true,
  $hzl_tcp_server_ips     = [],
  $hzl_aws_enabled        = false,
  $hzl_aws_access_key     = '',
  $hzl_aws_secret_key     = '',
  $hzl_aws_host_header    = 'ec2.amazonaws.com',
  $hzl_aws_region         = '',
  $commons_lang_version   = '3.3.2',
  $jcache_version         = '1.0.0',
  $wls_user               = '',
  $wls_pass               = '',
  $wls_admin_url          = '',
  $wls_domain_dir         = '/wl_domains/imdate/',
  $wls_app_cluster        = 'imdateAppCluster',
  $wls_app_servers        = ['imdateAppSrv1', 'imdateAppSrv2'],
  $wls_jms_cluster        = 'imdateJmsCluster',
  $wls_jms_servers        = ['imdateJmsSrv1', 'imdateJmsSrv2', 'imdateJmsSrv3', 'imdateJmsSrv4'],
  $deploy_on_wls          = false,
  $jms_input_type                 = 'javax.jms.Queue',
  $jms_input_connection_factory   = 'jms.star.DownSampling.ConnectionFactory',
  $jms_input_destination          = 'jms.star.DownSampling.PositionQueue',
  $jms_output_type                = 'not used?',
  $jms_output_connection_factory  = 'jms.star.DownSampling.IMDatEConnectionFactory',
  $jms_output_destination         = 'jms.star.DownSampling.imdate.OutputQueue',
  $max_future             = 3600,
  $cache_eviction         = 7200,
  $sat_ais_default        = 60,
  $t_ais_default          = 360,
  $oinstall_gid           = 115,
  $oracle_gid             = 115,
) {

  $artifact_dir   = "$root_dir/artifacts"
  $script_dir     = "$root_dir/scripts"
  $bin_dir        = "$root_dir/bin"
  $lib_dir        = "$root_dir/lib"
  $wls_dir        = "$root_dir/wls"
  $hzl_home       = "$root_dir/hazelcast-$hzl_version"

  $commons_lang_uri  = "http://central.maven.org/maven2/org/apache/commons/commons-lang3/$commons_lang_version/commons-lang3-$commons_lang_version.jar"
  $jcache_uri     = "http://central.maven.org/maven2/javax/cache/cache-api/$jcache_version/cache-api-$jcache_version.jar"

  $pkg            = "position-downsampling-ear-$version.ear"
  $pkg_old        = "position-downsampling-ear-$previous_version.ear"

  $app_name       = "postion_downsampling-$version"
  $app_old_name   = "postion_downsampling-$previous_version"


  
  class {'hazelcast':
    version => $hzl_version,  
    home  => $root_dir,
  }

  Exec { path   =>
    ['/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/']
  }

  case $operatingsystem {
    'RedHat', 'CentOS': {$packages = ['wget']}
    default:            {$packages = ['wget']}
  }
  
  ensure_packages($packages)

  ensure_resource('group', 'oinstall', {
      ensure => 'present', 
      gid    => "$oracle_gid",
    }
  )
 
  ensure_resource('user', 'oracle', {
    'ensure'          => present,
    'managehome'      => true,
    'groups'          => 'oinstall',
    'require'         => Group['oinstall'],
    'gid'             => "$oinstall_gid",
  })
      
  File {
    ensure            => 'present',
    owner             => 'oracle',
    group             => 'imdate',
    mode              => '0644',
    backup            => true,
  }

  file {["$bin_dir", "$lib_dir"]:
    ensure  => directory,
  }

  file {"$bin_dir/downsampling-server.sh":
    ensure  => file,
    content  => epp('emsa_downsampling/downsampling-server.sh.epp'),
    mode  => '0755',
  }

  file {"/etc/init.d/downsampling-cache":
    ensure  => file,
    content => epp('emsa_downsampling/downsampling-cache.sh.epp'),
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

  service {"downsampling-cache":
    enable    => true,
    require   => [ File["/etc/init.d/downsampling-cache"],
                   File["$bin_dir/downsampling-config.xml"]],
  }
  
  file {"$bin_dir/downsampling-config.xml":
    ensure  => file,
    content  => epp('emsa_downsampling/downsampling-config.xml.epp'),
  }

  exec {'download-commons-lang':
    command  => "wget $commons_lang_uri -O $lib_dir/commons-lang3-$commons_lang_version.jar",
    unless  => "test -f $lib_dir/commons-lang3-$commons_lang_version.jar",
  }

  exec {'download-jcache-api':
    command  => "wget $jcache_uri -O $lib_dir/cache-api-$jcache_version.jar",
    unless  => "test -f $lib_dir/cache-api-$jcache_version.jar",
  }

  exec {'download-ds-model': 
    # Should get the file from a common location, however currently no such 
    # location exists at EMSA
    command => "cp $artifact_dir/position-downsampling-model.jar $lib_dir",
    unless  => "test -f $lib_dir/position-downsampling-model.jar",
  }

  exec {'change-hzl-ownership':
    command   => "chown -R oracle:imdate $lib_dir",
  } 

  file {["$script_dir", "$script_dir/wlst"]:
      ensure  => directory,
  } ->

  file {"$script_dir/wlst/connect.py":
    ensure  => file,
    content  => epp('emsa_downsampling/connect.py.epp'),
    mode    => '0700',
  } ->

  exec {'ds_fetch_jms_functions':
    command  => "wget https://raw.githubusercontent.com/efpee/wlst/1.0.2/jms_functions.py -O $script_dir/wlst/jms_functions.py",
    unless  => "test -f $script_dir/wlst/jms_functions.py",
    require  => Package['wget'],
  } ->
  
  file {"$script_dir/wlst/create_jms_resources.py":
    ensure  => file,
    content  => epp('emsa_downsampling/create_jms_resources.py.epp'),
    mode    => '0755',
  } ->
  
  file {"$script_dir/wlst/deploy_downsampling.py":
    ensure  => file,
    content  => epp('emsa_downsampling/deploy_downsampling.py.epp'),
    mode    => '0755',
  } -> 

  file {"$script_dir/wlst/create_resources.py":
    ensure  => file,
    content  => epp('emsa_downsampling/create_resources.py.epp'),
    mode    => '0755',
  } ->

  file {'downsampling-wls-dir':
    ensure  => directory,
    path  => "$wls_dir", 
  } ->
  
  file {'downsampling-app-dir':
    ensure  => directory,
    path  => "$wls_dir/app", 
  } ->

  file {'downsampling-plan-dir':
    ensure  => directory,
    path  => "$wls_dir/plan",
  } ->

  file {'downsampling-overrides-dir':
    ensure  => directory,
    path  => "$wls_dir/plan/AppFileOverrides",
  } ->

  exec {"copy-downsampling-ear":
    command  => "cp $artifact_dir/$pkg $wls_dir/app",
  } ->

  exec {"delete-old-downsampling-ear":
    command  => "rm -f $wls_dir/app/$pkg_old",
  } ->

  file {'downsampling-plan':
    ensure  => file,
    path  => "$wls_dir/plan/Plan.xml",
    content  => epp('emsa_downsampling/Plan.xml.epp'),
  } ->

  file {"downsampling-config.properties":
    ensure  => file,
    path  => "$wls_dir/plan/AppFileOverrides/config.properties",
    content  => epp('emsa_downsampling/config.properties.epp'),
  } ->
  
  file {'hazelcast-client':
    ensure  => file,
    path  => "$wls_dir/plan/AppFileOverrides/hazelcast-client.xml",
    content  => epp('emsa_downsampling/hazelcast-client.xml.epp'),
  } ->

  file {'downsampling-wls-deploy-script':
    ensure  => file,
    path  => "$script_dir/deploy.sh",
    content  => epp('emsa_downsampling/deploy.sh.epp'),
    mode    => '0744',
  } ->

  exec {'change-wls-ownership':
    command  =>  "chown -R oracle:oinstall $wls_dir",
  } 

  if $deploy_on_wls == true {
    exec {'deploy-in-wls':
      command  =>  "$script_dir/deploy.sh",
    }
  }
}
