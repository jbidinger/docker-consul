#!/bin/bash

docker run -d -h consulnode1 --name consulnode1 jbconsul  agent -server -data-dir /var/consul -config-file /etc/consul.d/cluster.json -bootstrap-expect 3
JOIN_IP="$(docker inspect -f '{{.NetworkSettings.IPAddress}}' consulnode1)"
docker run -d -h consulnode2 --name consulnode2 jbconsul  agent -server -data-dir /var/consul -config-file /etc/consul.d/cluster.json -bootstrap-expect 3  -join ${JOIN_IP}
docker run -d -h consulnode3 --name consulnode3 jbconsul  agent -server -data-dir /var/consul -config-file /etc/consul.d/cluster.json -bootstrap-expect 3  -join ${JOIN_IP}

