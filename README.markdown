# Hadoop #

This module was created to assist with the installation and configuration of hadoop, specifically on Ubuntu 12.04. 
Simply edit the params.pp file and mapreduce your self away!

# Configuration #

* A deb file needs to be placed into ~/modules/hadoop/files. You can download hadoop from here: http://hadoop.apache.org/common/releases.html
* Once downloaded the params.pp file needs to be updated with the version downloaded. 
* The params.pp also requires the $java_home variable to be properly updated based on which version of java you plan to install. (This defaults to the openjdk-7-jre)

# SSH Keys #

The ssh keys for the hduser are in ~/files/ssh/ make sure you edit these files and put in your own public and private keys. If you are using this module for multiple hadoop servers the id_rsa.pub and id_rsa keys will be the same for each hduser. Also the authorized_keys file is defined in puppet as the id_rsa.pub file. If you wish to add support for other users you need to change the init.pp so authorized_keys is a differnt file in ~/files/ssh

# Cluster Mode #

Currently the configuration is setup for a cluster with at least 2 nodes. Each node needs to be named in params.pp the first node should be defined as $master and the other two nodes should be defined as $slaves.

If adding more than 2 nodes up $replication value to the number of total nodes in your cluster. Also add each node to the $slaves variable. 


# Author #
* Alex Mandel
* http://ice.ucdavis.edu

# Credits #
Based on work originally by
* Brian Carpio
* http://www.thetek.net
* http://www.linkedin.com/in/briancarpio
