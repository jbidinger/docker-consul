#!/bin/bash

docker run -d -h consulnode1 --name consulnode1 jbconsul  agent -server -config-file /etc/consul.d/cluster.json -bootstrap-expect 3
JOIN_IP="$(docker inspect -f '{{.NetworkSettings.IPAddress}}' consulnode1)"
docker run -d -h consulnode2 --name consulnode2 jbconsul  agent -server -config-file /etc/consul.d/cluster.json -bootstrap-expect 3  -join ${JOIN_IP}
docker run -d -h consulnode3 --name consulnode3 jbconsul  agent -server -config-file /etc/consul.d/cluster.json -bootstrap-expect 3  -join ${JOIN_IP}

docker run \
      -d -h consulagent1 --name consulagent1     \
      -p 8400:8400 -p 8500:8500 -p 8600:8600/udp \
      jbconsul  \
      agent -config-file /etc/consul.d/agent.json \
      -config-file /etc/consul.d/service.consul-ui.json \
      -client 0.0.0.0 -join ${JOIN_IP}

