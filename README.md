# k8s-unboxing
Generally I use kvm in my home lab, poor man's hypervisor. You need some sort of automation so that you can quickly change, build, destroy & redo a cluster whenever you want in the cheapest way possible.

Purpose of this very first blog of this series is to introduce the following collection of scripts which let you create a k8s cluster with an api load balancer with both libvirt (kvm) and virtualbox.

Once download first thing you would like to do is to update k8s-config.yaml

<pre><code>
## global definitions
# k8s:
#   provider: 'libvirt'             ## two options 'libvirt' or 'virtualbox'#######################################
#   domain: 'k8s.local'
#   ip_start: 192.168.121.128       ## This is required for libvirt provider to create a subnet ###################
#   ip_end: 192.168.121.254         ## for virtualbox its use the default vboxnet0 ################################
#   ncpnd: 1                        ## number of master nodes, load balancer will balanced the traffic to kubeapi##
#   nwrknd: 2                       ## number of worker nodes #####################################################
#   cni: "default"                  ## 3 options 'default'(simple routing & no 3rd party CNI),'calico','cilium' ###
#   V: 1.22                         ## k8s version ################################################################
#   CRI_CTL_V: 1.25                 ## CRI version ################################################################
#   RUNC_V: 1.1                     ## runc version ###############################################################
#   CONTD_V: 1.6                    ## containerd version #########################################################
#   CNI_PLUGIN_V: 1.1               ## cni plugin version #########################################################
#   build_directory: "<path>"       ## path to the directory where you downloaded & build all k8s related source ## 
# node:                             ## any node attrebutes can be configured here #################################      
#   private_key_name: "<ssh_key>"   ## ssh key name to ssh into the nodes,expect key in default ~/.ssh path #######

k8s:
  provider: "libvirt"
  domain: "<domain>"
  ip_start: 192.168.121.128
  ip_end: 192.168.121.254
  ncpnd: 1
  nwrknd: 2
  cni: "default"
  V: 1.22
  CRI_CTL_V: 1.25
  RUNC_V: 1.1
  CONTD_V: 1.6
  CNI_PLUGIN_V: 1.1
  build_directory: "<path>"
node:
  private_key_name: "<ssh_key>"
  os: "generic/ubuntu2204"
</code></pre>
Github repo documentation still a work in progress and grow along with this series and will bring more clarity, it's only bash scripts (other than one exception of ansible, just to keep an entry point for future enhancement), using only bash is intentional, code is very much straight forward easy to understand and change and that is the primary objectives.

following table would be helpful
|command|usage|
|-------|-----|
| ./setup.sh make | Download source code for Kubernetes, Cri-tools, runc, containerd & cni plugins. |
| ./setup.sh build | Build Kubernetes, Cri-tools, runc, containerd & cni plugins and copy to the main project tmp folder, so that any changes made to any of this source is readily available for testing.|
||**NOTE:** etcd is the only binary which is getting downloaded and not getting build locally|
| ./setup.sh all | Create control plane vm's, load balancer and worker nodes based on the k8s-config configuration and install all the binaries |
| ./setup.sh cp | Only creates the control plane |
| ./setup.sh wrk | If control plane exists creates worker nodes and configure the same |
| ./setup.sh del | Destroy entire cluster |
| ./setup.sh del wrk | Only remove the worker nodes, so that you can redeploy the worker nodes with changes you made, keeping the control plane intact |

FYI- "build" for the first time will take some time mostly to build k8s binaries, do check "build-k8s.sh" under scripts directory for the build command and you are free to make changes according to your environment
 <pre><code>
    sudo build/run.sh make kube-apiserver KUBE_BUILD_PLATFORMS=linux/amd64
    sudo build/run.sh make kube-controller-manager KUBE_BUILD_PLATFORMS=linux/amd64
    sudo build/run.sh make kube-scheduler KUBE_BUILD_PLATFORMS=linux/amd64
    sudo build/run.sh make kubectl KUBE_BUILD_PLATFORMS=linux/amd64
    sudo build/run.sh make kube-proxy KUBE_BUILD_PLATFORMS=linux/amd64
    sudo build/run.sh make kubelet KUBE_BUILD_PLATFORMS=linux/amd64
</code></pre>

Building containerd may have some complain around libseccomp and you may download compile build the same with following commands
<pre><code>git clone https://github.com/seccomp/libseccomp
git checkouot release-2.5
./autogen.sh
./configure
make install
make check
</code></pre>

Sometimes changing virtualization providers from virtualbox to libvirt causes some trouble simply restart libvirtd and remove stale images.

Few things to remember before using this repo.

1. Its inspired by "kubernetes the hard way"- it's just an enhancement to use cheaper infra provisioning platform or tools like virtualbox or kvm
2. This is not any tool or has no intention to become one, in fact its opposites, its whole purpose is to unwrap installation and configuration of a cluster in its full glory
3. This is no way optimized for time (it takes to build a cluster) or efficiency (I purposefully avoided using ansible or any sorts of cm), it's expressive and fragile.
4. I have ansible provisioner with vagrant, but use has been kept very limited, its mostly collection of few bash script and that is intentional
* Pre-requisites
  * I use ubuntu for my development machine, it should also work in a debian distribution
  * [Go](https://www.fosslinux.com/68795/install-go-on-ubuntu.htm)
  * [Kvm](https://www.fosslinux.com/68795/install-go-on-ubuntu.htm) or [virtualbox](https://linuxhint.com/install-virtualbox-linux/)- 
    I should warn kvm is much much faster, reason is obvious kvm is type 1 hypervisor
  * [Vagrant](https://linuxhint.com/install-vagrant-ubuntu/), vagrant virtualbox provider and [libvirt providers](https://computingforgeeks.com/using-vagrant-with-libvirt-on-linux/)
  * Virsh and Vboxmanage command lines, which should be installed once you configured libvirt and virtualbox
  * Cilium command line if you are using cilium, but my suggestions would be to start with default
  * If anything else, rest assured deployment will certainly break and let you know what is wrong :-)
  * It will ask for "sudo", you are welcome to check the code before you go with it, nothing harmful though

