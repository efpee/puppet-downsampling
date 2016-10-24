# == Class: emsa_downsampling
#
# Full description of class emsa_downsampling here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'emsa_downsampling':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2016 Your name here, unless otherwise noted.
#
class emsa_downsampling (
	$version				  = '1.1.2',
	$previous_version	= '1.1.2',
	$root_dir				  = '/downsampling',
	$java_home				= '/usr/bin/java',
	$hzl_version			= '3.4.2',
	$hzl_cluster			= 'star',
	$hzl_pass				  = '',
	$hzl_man_center_enabled	= 'false',
	$hzl_man_center_uri		= 'http://localhost:8080/mancenter',
	$hzl_multicast_enabled = 'false',
	$hzl_multicast_group  = '224.2.2.3',
	$hzl_multicast_port		= '54327',
	$hzl_tcp_enabled		  = 'true',
	$hzl_tcp_server_ips		= [],
	$hzl_aws_enabled		  = 'false',
	$hzl_aws_access_key		= 'my_aws_key',
	$hzl_aws_secret_key		= 'a dark secret',
	$hzl_aws_host_header	= 'ec2.amazonaws.com',
	$hzl_aws_region			  = 'us-east-1',
	$commons_lang_version	= '3.3.2',
	$jcache_version			  = '1.0.0',
	$wls_user				      = '',
	$wls_pass				      = '',
	$wls_admin_url			  = '',
	$wls_domain_dir			  = '/wl_domains/imdate/',
  $wls_app_cluster      = 'imdateAppCluster',
  $wls_app_servers      = ['imdateAppSrv1', 'imdateAppSrv2'],
  $wls_jms_cluster      = 'imdateJmsCluster',
  $wls_jms_servers      = ['imdateJmsSrv1', 'imdateJmsSrv2', 'imdateJmsSrv3', 'imdateJmsSrv4'],
) {

	$artifact_dir   = "$root_dir/artifacts"
	$script_dir     = "$root_dir/scripts"
	$wls_dir        = "$root_dir/wls"
	$hzl_home       = "$root_dir/hazelcast-$hzl_version"

	$commons_lang_uri	= "http://buildenv:8085/repository/internal/org/apache/commons/commons-lang3/$commons_lang_version/commons-lang3-$commons_lang_version.jar"
	$jcache_uri     = "http://central.maven.org/maven2/javax/cache/cache-api/$jcache_version/cache-api-$jcache_version.jar"

	$pkg            = "position-downsampling-ear-$version.ear"
	$pkg_old        = "position-downsampling-ear-$previous_version.ear"

	$app_name       = "postion_downsampling-$version"
	$app_old_name   = "postion_downsampling-$previous_version"


	
	class {'hazelcast':
		version => $hzl_version,	
		home	=> $root_dir,
	}

	Exec { path 	=>
		['/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/']
	}

  ensure_packages(['git'])

  ensure_resource('group', 'oinstall', {ensure => 'present', gid => 115,})
 
  ensure_resource('user', 'oracle', {
    'ensure'          => present,
    'managehome'      => true,
    'groups'          => 'oinstall',
    'require'         => Group['oinstall'],
    'gid'             => 115,
  })
      
  File {
    ensure              => 'present',
    owner               => 'oracle',
    group               => 'imdate',
    mode                => '0644',
    backup              => true,
  }

	file {"$hzl_home/bin/downsampling-server.sh":
		ensure	=> file,
		content	=> epp('emsa_downsampling/downsampling-server.sh.epp'),
		mode	=> '0755',
		require	=> User['oracle'],
	}

	file {"$hzl_home/downsampling-cache.sh":
		ensure	=> file,
		content	=> epp('emsa_downsampling/downsampling-cache.sh.epp'),
		mode	=> '0755',
		require	=> User['oracle'],
	}
	
	file {"$hzl_home/bin/downsampling-config.xml":
		ensure	=> file,
		content	=> epp('emsa_downsampling/downsampling-config.xml.epp'),
		require	=> User['oracle'],
	}

	exec {'download-commons-lang':
		command	=> "wget $commons_lang_uri -O $hzl_home/lib/commons-lang3-$commons_lang_version.jar",
		unless	=> "test -f $hzl_home/lib/commons-lang3-$commons_lang_version.jar",
	}

	exec {'download-jcache-api':
		command	=> "wget $jcache_uri -O $hzl_home/lib/cache-api-$jcache_version.jar",
		unless	=> "test -f $hzl_home/lib/cache-api-$jcache_version.jar",
	}

	exec {'download-model': 
		# Should get the file from a common location, however currently no such 
		# location exists at EMSA
		command => "mv $artifact_dir/position-downsampling-model.jar $hzl_home/lib/",
		onlyif	=> "test -f $artifact_dir/position-downsampling-model.jar",
	}

	file {"$script_dir":
    	ensure  => directory,
    } ->

	file {"$script_dir/wlst":
		ensure	=> directory,
	} ->

	file {"$script_dir/wlst/connect.py":
		ensure	=> file,
		content	=> epp('emsa_downsampling/connect.py.epp'),
		mode    => '0700',
	} ->

	file {"$script_dir/wlst/jms_functions.py":
		# this could be reused in the other projects
		ensure	=> file,
		content	=> epp('emsa_downsampling/jms_functions.py.epp'),
		mode    => '0755',
	} -> 

	file {"$script_dir/wlst/create_jms_resources.py":
		ensure	=> file,
		content	=> epp('emsa_downsampling/create_jms_resources.py.epp'),
		mode    => '0755',
	} ->
	
	file {"$script_dir/wlst/deploy_downsampling.py":
		ensure	=> file,
		content	=> epp('emsa_downsampling/deploy_downsampling.py.epp'),
		mode    => '0755',
	} -> 

	file {"$script_dir/wlst/create_resources.py":
		ensure	=> file,
		content	=> epp('emsa_downsampling/create_resources.py.epp'),
		mode    => '0755',
	} ->

	file {'wls-dir':
		ensure	=> directory,
		path	=> "$wls_dir", 
	} ->
	
	file {'app-dir':
		ensure	=> directory,
		path	=> "$wls_dir/app", 
	} ->

	file {'plan-dir':
		ensure	=> directory,
		path	=> "$wls_dir/plan",
	} ->

	file {'overrides-dir':
		ensure	=> directory,
		path	=> "$wls_dir/plan/AppFileOverrides",
	} ->

	exec {"copy-ear":
		command	=> "cp $artifact_dir/$pkg $wls_dir/app",
	} ->

	exec {"delete-old-ear":
		command	=> "rm -f $wls_dir/app/$pkg_old",
	} ->

	file {'plan':
		ensure	=> file,
		path	=> "$wls_dir/plan/Plan.xml",
		content	=> epp('emsa_downsampling/Plan.xml.epp'),
	} ->

	file {'hazelcast-client':
		ensure	=> file,
		path	=> "$wls_dir/plan/AppFileOverrides/hazelcast-client.xml",
		content	=> epp('emsa_downsampling/hazelcast-client.xml.epp'),
	} ->

	file {'wls-deploy-script':
		ensure	=> file,
		path	=> "$script_dir/deploy.sh",
		content	=> epp('emsa_downsampling/deploy.sh.epp'),
		mode    => '0744',
	} ->

	exec {'change-ownership':
		command	=>	"chown -R oracle:oinstall $wls_dir",
	} 

  # No automatic deploy as module will be installed on multiple servers but 
  # installation is needed only once
	#exec {'deploy-in-wls':
	#	command	=>	"$script_dir/deploy.sh",
	#}

}
