## Make sure auto-completion for the OC command is enabled so that pod names are easy to access (pods have randomly generated endings)
```
source <(oc completion bash)
```

## Create two projects
```
oc new-project samespace
oc new-project diffspace
```

## Create three sample apps
```
oc new-app -n samespace --name samespace-1 --docker-image quay.io/redhattraining/hello-world-nginx:v1.0
oc new-app -n samespace --name samespace-2 --docker-image quay.io/redhattraining/hello-world-nginx:v1.0
oc new-app -n diffspace --name diffspace-1 --docker-image quay.io/redhattraining/hello-world-nginx:v1.0
```

## Add a route to samespace B
```
oc expose service samespace-2
```

## Check the two projects
```
oc status
oc get all
```

## Make a little shell script if it would be helpful to quickly get the IP addresses 
```
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
oc get pods -o custom-columns="POD NAME:.metadata.name,IP ADDRESS:.status.podIP" -n diffspace
```

## Verify samespace A can reach the pod IP and the service IP of samespace B (make sure you get the real IP from the above commands and use autocompletion to save typing)
```
oc rsh samespace-1-<guid> curl 10.8.0.3:8080
oc rsh samespace-1-<guid> curl 172.30.0.3:8080
```

## Check the route for good measure (this can be done from a machine outside your cluster)
```
curl -s samespace-2-samespace.apps.ocp4.disconnect.blue
```

## Demonstrate denying all traffic (any policy changes default traffic from accept to deny [blacklist to whitelist])
```
oc get networkpolicy
```
```
vim deny-all.yaml
```
```
kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
  name: deny-all
spec:
  podSelector: {}
```

## Apply network policy
```
oc create -f deny-all.yaml
```
```
oc get networkpolicy
```

## Check the route to see if you are able to access it
```
curl -s samespace-2-samespace.apps.ocp4.disconnect.blue
```

## Check if a different namespace to samespace-b 
```
oc rsh diffspace-1-<guid> curl 10.8.0.3:8080
```

## Check if the same namespace can reach samespace-b
```
oc rsh samespace-1-<guid> curl 10.8.0.3:8080
```
