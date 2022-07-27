#!/usr/bin/env bash

InputNamespace=$1
NginxNamespace=${2:-'base-services'}
NginxPod=$(kubectl -n "$NginxNamespace" get pods -l app.kubernetes.io/name=nginx --no-headers -o name | head -n1)
AllNamespaces=$(kubectl get ns --no-headers --output name | cut -d "/" -f 2)
for Namespace in ${InputNamespace:-$AllNamespaces}
do
	for svc in $(kubectl -n $Namespace get svc --no-headers | tr -s " " | awk -v NAMESPACE=$Namespace -F " " '{print $1"."NAMESPACE".svc:"$5}' | cut -d "/" -f 1)
	do 
		kubectl -n base-services exec $NginxPod -- curl -m1 -v $svc 1>/dev/null 2>&1
		if [ $? -ne 0 ]
		then 
			printf "Namespace:$Namespace \t Service:$svc Good\n"
		else 
			printf "Namespace:$Namespace \t Service:$svc Not good\n"
		fi
	done
done
