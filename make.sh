#!/bin/bash

project_path=$(eval pwd)
#k8s_build_directory=../k8s_build_lab


if [ -d .tmp ];
then
	echo "tmp folder exists"
else
	mkdir .tmp
fi

echo $k8s_build_directory

if [ -d $k8s_build_directory ];
then
	echo "k8s build directory exists"
else
	mkdir $k8s_build_directory
fi
repo_KUBE=$k8s_build_directory/kubernetes
repo_CRI_CTL=$k8s_build_directory/cri-tools
repo_RUNC=$k8s_build_directory/runc
repo_CONTD=$k8s_build_directory/containerd
repo_CNI_plug=$k8s_build_directory/plugins

cd $k8s_build_directory

if [ -d "$repo_KUBE" ];
then
    echo "k8s repo exists - delete local folder to download again"
else
    echo "downloading kubernetes source"
    git clone https://github.com/kubernetes/kubernetes.git
fi
if [ -d "$repo_CRI_CTL" ];
then
    echo "cri-tool repo exists - delete local folder to download again"
else
    echo "downloading cri-tool source"
    git clone https://github.com/kubernetes-sigs/cri-tools.git
fi
if [ -d "$repo_RUNC" ];
then
    echo "runc repo exists - delete local folder to download again"
else
    echo "downloading runc source"
    git clone https://github.com/opencontainers/runc.git
fi
if [ -d "$repo_CONTD" ];
then
    echo "containerd repo exists - delete local folder to download again"
else
    echo "downloading conteinder source"
    git clone https://github.com/containerd/containerd
fi
if [ -d "$repo_CNI_plug" ];
then
    echo "cni plugins repo exists - delete local folder to download again"
else
    echo "downloading cni plugins source"
    git clone https://github.com/containernetworking/plugins.git
fi

cd $project_path