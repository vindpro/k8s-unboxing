#!/bin/bash
kubectl create deployment testingress --image=nginx --replicas=10 
kubectl run busybox --image=busybox:1.28 --command -- sleep 3600

POD_NAME=$(kubectl get pods -l run=busybox -o jsonpath="{.items[0].metadata.name}")
kubectl exec -ti $POD_NAME -- nslookup kubernetes

kubectl create secret generic kubernetes-the-hard-way \
  --from-literal="mykey=mydata"

ssh-keygen -f "/home/vindpro/.ssh/known_hosts" -R "k8s-master-1.vindpro.de"

ssh -i ~/.ssh/vindpro_local vagrant@k8s-master-1.vindpro.de -oStrictHostKeyChecking=no 'exit'



ssh -i ~/.ssh/vindpro_local vagrant@k8s-master-1.vindpro.de -- \
  "sudo ETCDCTL_API=3 /usr/local/bin/etcdctl get \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/etcd/ca.pem \
  --cert=/etc/etcd/kubernetes.pem \
  --key=/etc/etcd/kubernetes-key.pem\
  /registry/secrets/default/kubernetes-the-hard-way | hexdump -C"
