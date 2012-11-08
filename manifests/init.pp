# /etc/puppet/modules/hadoop/manafests/init.pp
# Rewritten to use cloudera packages CDH4

class hadoop {

	require hadoop::params
	require hadoop::cluster

	include hadoop::cluster::namenode
	include hadoop::cluster::secondary
	include hadoop::cluster::datanodes

    Exec { path => '/usr/bin:/bin:/usr/sbin:/sbin' }
	
	#Create the hadoop group
	group { "hdfs":
		ensure => present,
	}

    #Create the hadoop user
	user { "hdfs":
		ensure => present,
		comment => "Hadoop",
		password => "!!",
		uid => "800",
		gid => "800",
		shell => "/bin/bash",
		home => "/home/hdfs",
		require => Group["hdfs"],
	}
	
	#Create the Bash env for the hadoop user
	file { "/home/hdfs/.bash_profile":
		ensure => present,
		owner => "hdfs",
		group => "hadoop",
		alias => "hdfs-bash_profile",
		content => template("hadoop/home/bash_profile.erb"),
		require => User["hduser"]
	}
	
	#Ensure the hadoop user home directory	
	file { "/home/hdfs":
		ensure => "directory",
		owner => "hdfs",
		group => "hdfs",
		alias => "hduser-home",
		require => [ User["hduser"], Group["hadoop"] ]
	}

    file { "/hadoop":
		ensure => "directory",
		owner => "hduser",
		group => "hadoop",
		alias => "hdfs-path",
		require => [ User["hduser"], Group["hadoop"] ]
	}
    #Ensure the hadoop hdfs paths in the params exist and are owned by the group/user
    #TODO: how to work with subdirectories, should it just be /hadoop or can it be subdir so it's easy to add?
	file {"$hadoop::params::hdfs_path":
		ensure => "directory",
		owner => "hduser",
		group => "hadoop",
		alias => "hdfs-dir",
		require => File["hdfs-path"]
	}
	
	#Ensure the hadoop configuration directory exists
	file {"$hadoop::params::hadoop_base":
		ensure => "directory",
		owner => "hduser",
		group => "hadoop",
		alias => "hadoop-base",
	}

   	package { ['gdisk']:
		ensure => present,
		alias => "gdisk",
		before => Exec['hadoop-java']
	}
	
	package { ['openjdk-7-jdk']:
		ensure => present,
		alias => "openjdk",
		before => Exec['hadoop-java']
	}
	
	exec { "update-java-alternatives":
		command => "/usr/sbin/update-java-alternatives -s ${hadoop::params::version}-x86_64.deb",
		alias => "hadoop-java",
		refreshonly => true,
		#user => "hduser", Might not be needed
		before => File["hadoop-deb"]
	}
    #Check that you have the deb package, might not be needed now
	file { "${hadoop::params::hadoop_base}/hadoop_${hadoop::params::version}.deb":
		mode => 0644,
		owner => hduser,
		group => hadoop,
		source => "puppet:///modules/hadoop/hadoop_${hadoop::params::version}.deb",
		alias => "hadoop-deb",
		before => Package["dpkg-hadoop"],
		require => [ File["hadoop-base"], Package["gdisk"],Package["openjdk"] ] #syntax check?
	}
	
	#Install using the offical debs from the Apache hadoop site, works on all flavors of debian, better use the package manager
	package { 'hadoop':
	    ensure => installed,
	    provider => 'dpkg',
	    source => "${hadoop::params::hadoop_base}/hadoop_${hadoop::params::version}.deb",
	    #Should source use the puppet file reference?, dpkg doesn't resolve puppet://
	    alias => "dpkg-hadoop",
	    require => [File["hadoop-deb"],Exec["update-java-alternatives"] ]
	}
	
	#Add the configuration based on templates
	file { "${hadoop::params::hadoop_base}/core-site.xml":
		owner => "hduser",
		group => "hadoop",
		mode => "644",
		alias => "core-site-xml",
		content => template("hadoop/conf/core-site.xml.erb"),
	}
	
	file { "${hadoop::params::hadoop_base}/hdfs-site.xml":
		owner => "hduser",
		group => "hadoop",
		mode => "644",
		alias => "hdfs-site-xml",
		content => template("hadoop/conf/hdfs-site.xml.erb"),
	}
	
	file { "${hadoop::params::hadoop_base}/hadoop-env.sh":
		owner => "hduser",
		group => "hadoop",
		mode => "644",
		alias => "hadoop-env-sh",
		content => template("hadoop/conf/hadoop-env.sh.erb"),
	}
	
	exec { "hadoop namenode -format":
	    path    => ["/usr/bin", "/usr/sbin","${hadoop::params::hadoop_base}/hadoop_bin"],
		user => "hduser",
		alias => "format-hdfs",
		refreshonly => true,
		subscribe => File["hdfs-dir"],
		require => [ File["hduser-bash_profile"], File["mapred-site-xml"], File["hdfs-site-xml"], File["core-site-xml"], File["hadoop-env-sh"]]
	}
	
	file { "${hadoop::params::hadoop_base}/mapred-site.xml":
		owner => "hduser",
		group => "hadoop",
		mode => "644",
		alias => "mapred-site-xml",
		content => template("hadoop/conf/mapred-site.xml.erb"),		
	}
	

}
