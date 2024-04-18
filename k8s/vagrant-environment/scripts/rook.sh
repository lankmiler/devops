#!/bin/bash

## Installing rook ceph cluster
#helm install --create-namespace --namespace rook-ceph rook-ceph rook-release/rook-ceph -f values.yaml

cd /tmp

kubectl taint nodes --all node-role.kubernetes.io/master-

git clone --single-branch --branch v1.10.8 https://github.com/rook/rook.git
cd rook/deploy/examples/

kubectl create -f crds.yaml -f common.yaml -f operator.yaml

