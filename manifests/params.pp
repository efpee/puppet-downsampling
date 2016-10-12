class emsa_downsampling::params {
	$version				= '1.1.2'
	$pkg					= "position-downsampling-ear-$version.ear"
	$artifact_dir			= '/imdate/artifacts'

	$java_home				= '/usr/bin/java'

	$hazelcast_version		= '3.4.2'
	$hazelcast_home			= '/imdate/hazelcast-$hazelcast_version'
	$hazelcast_cluster		= 'star'
	$hazelcast_pass			= 'darkstar-t'
	$management_center_enabled	= 'false'
	$management_center_uri	= 'http://localhost:8080/mancenter' 
	$multicast_enabled		= 'false'
	$multicast_group		= '224.2.2.3'
	$multicast_port			= '54327'
	$tcp_enabled			= 'true'
	$tcp_server_ips			= ['172.16.122.147', '172.16.122.147', '172.16.122.190']
	$aws_enabled			= 'false'	
	$aws_access_key			= 'my_aws_key'
	$aws_secret_key			= 'a dark secret'
	$aws_host_header		= 'ec2.amazonaws.com'

	$commons_lang_version	= '3.3.2'
	$commons_lang_uri		= "http://buildenv:8085/repository/internal/org/apache/commons/commons-lang3/$commons_lang_version/commons-lang3-$commons_lang_version.jar"

	$jcache_version			= '1.0.0'
	$jcache_uri				= "http://central.maven.org/maven2/javax/cache/cache-api/$jcache_version/cache-api-$jcache_version.jar"

}
