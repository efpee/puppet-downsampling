class emsa_downsampling::hazelcast_config {

  class {'hazelcast':
    version => $emsa_downsampling::hzl_version,  
    home  => $emsa_downsampling::root_dir,
  }


  file {["$emsa_downsampling::bin_dir", "$emsa_downsampling::lib_dir"]:
    ensure  => directory,
  }

  file {"$emsa_downsampling::bin_dir/downsampling-server.sh":
    ensure  => file,
    content  => epp('emsa_downsampling/downsampling-server.sh.epp'),
    mode  => '0755',
    require => File["$emsa_downsampling::bin_dir"],
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
                   File["$emsa_downsampling::bin_dir"],
                   File["$emsa_downsampling::bin_dir/downsampling-config.xml"]],
  }
  
  file {"$emsa_downsampling::bin_dir/downsampling-config.xml":
    ensure  => file,
    content  => epp('emsa_downsampling/downsampling-config.xml.epp'),
    require => File["$emsa_downsampling::bin_dir"],
  }

  exec {'download-commons-lang':
    command  => "wget $emsa_downsampling::commons_lang_uri -O $emsa_downsampling::lib_dir/commons-lang3-$emsa_downsampling::commons_lang_version.jar",
    unless  => "test -f $emsa_downsampling::lib_dir/commons-lang3-$emsa_downsampling::commons_lang_version.jar",
    require => File["$emsa_downsampling::lib_dir"],
  }

  exec {'download-jcache-api':
    command  => "wget $emsa_downsampling::jcache_uri -O $emsa_downsampling::lib_dir/cache-api-$emsa_downsampling::jcache_version.jar",
    unless  => "test -f $lib_dir/cache-api-$emsa_downsampling::jcache_version.jar",
    require => File["$emsa_downsampling::lib_dir"],
  }

  exec {'download-ds-model': 
    # Should get the file from a common location, however currently no such 
    # location exists at EMSA
    command => "cp $emsa_downsampling::artifact_dir/position-downsampling-model.jar $emsa_downsampling::lib_dir",
    unless  => "test -f $emsa_downsampling::lib_dir/position-downsampling-model.jar",
    require => File["$emsa_downsampling::lib_dir"],
  }

  exec {'change-lib-ownership':
    command   => "chown -R $owner:$group $emsa_downsampling::lib_dir",
    require => [File["$emsa_downsampling::lib_dir"],
                Exec['download-commons-lang'],
                Exec['download-jcache-api'],
                Exec['download-ds-model']],
  } 

}
