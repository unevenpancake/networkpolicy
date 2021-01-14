#!/usr/bin/bash
echo "PROJECT: samespace"
echo
oc get pods -o custom-columns="POD NAME:.metadata.name,IP ADDRESS:.status.podIP" -n samespace
echo
oc get svc -o custom-columns="SERVICE NAME:.metadata.name,CLUSTER-IP:.spec.clusterIP" -n samespace
echo
oc get route -o custom-columns="ROUTE NAME:.metadata.name,HOSTNAME:.spec.host,PORT:.spec.port.targetPort" -n samespace

echo "PROJECT: diffspace"
echo
oc get pods -o custom-columns="POD NAME:.metadata.name" -n diffspace
