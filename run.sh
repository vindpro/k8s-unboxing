#!/bin/bash

export k8s_provider="virtualbox"
export k8s_domain="vindpro.de"
export k8s_ip_start="192.168.121.128"
export k8s_ip_end="192.168.121.254"
export k8s_ncpnd="1"
export k8s_nwrknd="2"
export k8s_cni="default"
export k8s_V="1.22"
export k8s_CRI_CTL_V="1.25"
export k8s_RUNC_V="1.1"
export k8s_CONTD_V="1.6"
export k8s_CNI_PLUGIN_V="1.1"
export k8s_build_directory="/home/vindpro/github/k8s_build_lab"
export node_cp_cpu="1"
export node_cp_mem="2048"
export node_wrk_cpu="2"
export node_wrk_mem="2048"
export node_lb_cpu="1"
export node_lb_mem="2048"
./destroy.sh $k8s_provider