#!/usr/bin/env bash
#Script created to launch Jmeter tests directly from the current terminal without accessing the jmeter master pod.
#It requires that you supply the path to the jmx file
#After execution, test script jmx file may be deleted from the pod itself but not locally.

working_dir=`pwd`

#Get namesapce variable
tenant=`awk '{print $NF}' $working_dir/tenant_export`
echo $tenant

master_pod=`kubectl get po -n $tenant | grep jmeter-master | awk '{print $1}'`

echo $master_pod

echo "copued jmx file"

kubectl exec -ti -n $tenant $master_pod -- cp -r /load_test /jmeter/load_test
echo "copied loadtest to jmeter folder on pod "
kubectl exec -ti -n $tenant $master_pod -- chmod 755 /jmeter/load_test
echo "chaging permision is done"
## Echo Starting Jmeter load test
echo "jmeter started"
kubectl exec -ti -n $tenant $master_pod -- /jmeter/load_test /azurejmeter/jmetermaster/Identifi_All_Apps.jmx
echo "jmeter test is completed"
