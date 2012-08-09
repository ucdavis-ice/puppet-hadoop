# /etc/puppet/modules/hadoop/manifests/params.pp

class hadoop::params {
    
    #Where do the java params come from?
	#include java::params

	$version = $::hostname ? {
		default			=> "1.0.3-1_x86_64",
	}
        
	$master = $::hostname ? {
		default			=> "ice1",
	}
        
	$slaves = $::hostname ? {
		default			=> [ice1, ice2] 
	}
	$hdfsport = $::hostname ? {
		default			=> "8020",
	}

	$replication = $::hostname ? {
		default			=> "2",
	}

	$jobtrackerport = $::hostname ? {
		default			=> "8021",
	}
	
	$java_base =  $::hostname ? {
		default			=> "/usr/lib/jvm",
	}
	$java_version =  $::hostname ? {
		default			=> "java-1.7.0-openjdk",
	}
	
	$java_home = $::hostname ? {
		default			=> "${params::java_base}/${params::java_version}",
	}
	$hadoop_base = $::hostname ? {
		default			=> "/etc/hadoop",
	}
	$hdfs_path = $::hostname ? {
		default			=> "/hadoop/disk1,/hadoop/disk2",
	}
}
