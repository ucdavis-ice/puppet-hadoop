# /etc/puppet/modules/hadoop/manifests/params.pp

class hadoop::params {
    
    #Where do the java params come from?
	#include java::params

	#$version = $::hostname ? {
	#	default			=> "1.0.3-1_x86_64",
	#}
        
	$namenode = $::hostname ? {
		default     => "h1",
	}
    
    $secondary = $::hostname ? {
        default     => "h2",
    }
    
	$datanodes = $::hostname ? {
		default		=> [h1, h2] 
	}
	
	$backupaddress = $::hostname ? {
	    default     => "${params::secondary}:50100"
	}
	
	$backupaddresshttp = $::hostname ? {
	    default     => "${params::secondary}:50105"
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
		default			=> "${params::java_base}/${params::java_version}-amd64",
	}
	$hadoop_base = $::hostname ? {
		default			=> "/etc/hadoop",
	}
	$hdfs_path = $::hostname ? {
		default			=> "/hadoop/disk1"
	}
}
