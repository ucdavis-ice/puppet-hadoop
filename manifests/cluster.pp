# /etc/puppet/modules/hadoop/manifests/master.pp

class hadoop::cluster {
	# do nothing, magic lookup helper
}

class hadoop::cluster::namenode {
	
        file { "${hadoop::params::hadoop_base}/namenode":
		owner => "hduser",
		group => "hadoop",
		mode => "644",
		alias => "hadoop-namenode",
		content => template("hadoop/conf/namenode.erb"),		
	}

}

class hadoop::cluster::secondary {
	
        file { "${hadoop::params::hadoop_base}/secondary":
		owner => "hduser",
		group => "hadoop",
		mode => "644",
		alias => "hadoop-secondary",
		content => template("hadoop/conf/secondary.erb"),		
	}

}

class hadoop::cluster::datanodes {
        file { "${hadoop::params::hadoop_base}/datanodes":
		owner => "hduser",
		group => "hadoop",
		mode => "644",
		alias => "hadoop-datanodes",
		content => template("hadoop/conf/datanodes.erb"),		
	}
}

class hadopp::cluster::fuse {
}
