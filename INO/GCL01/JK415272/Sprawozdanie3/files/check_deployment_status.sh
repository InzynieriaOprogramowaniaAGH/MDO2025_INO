KUBECTL_CMD="/usr/bin/minikube kubectl --"

DEPLOYMENT_NAME="mdoapp-deployment"
APP_LABEL="mdoapp"
TIMEOUT_SECONDS=60
INTERVAL_SECONDS=5
elapsed_time=0

echo "Checking deployment status for '$DEPLOYMENT_NAME'..."

while [ $elapsed_time -lt $TIMEOUT_SECONDS ]; do

    desired_replicas=$($KUBECTL_CMD get deployment $DEPLOYMENT_NAME -o jsonpath='{.spec.replicas}')
    if [ -z "$desired_replicas" ]; then
        echo "Error: Could not get desired replicas for deployment $DEPLOYMENT_NAME."

        $KUBECTL_CMD get deployment $DEPLOYMENT_NAME 
        exit 1
    fi
    
   
    ready_replicas=$($KUBECTL_CMD get deployment $DEPLOYMENT_NAME -o jsonpath='{.status.readyReplicas}')
    if [ -z "$ready_replicas" ]; then
        ready_replicas=0
    fi

 
    updated_replicas=$($KUBECTL_CMD get deployment $DEPLOYMENT_NAME -o jsonpath='{.status.updatedReplicas}')
    if [ -z "$updated_replicas" ]; then
        updated_replicas=0
    fi

    echo "Status: Desired=$desired_replicas, Updated=$updated_replicas, Ready=$ready_replicas"

 
    if [ "$ready_replicas" -eq "$desired_replicas" ] && \
       [ "$updated_replicas" -eq "$desired_replicas" ] && \
       [ "$desired_replicas" -ne "0" ]; then
        
        echo "Deployment '$DEPLOYMENT_NAME' is ready with $ready_replicas replicas."
        
   
        all_pods_running=true
        pod_statuses=$($KUBECTL_CMD get pods -l "app=$APP_LABEL" -o jsonpath='{range .items[*]}{.status.phase}{"\n"}{end}')
        
      
        if [ -z "$pod_statuses" ] && [ "$desired_replicas" -ne "0" ]; then
            echo "Warning: No pods found for app label '$APP_LABEL', but desired replicas is $desired_replicas."
            all_pods_running=false 
        elif [ -n "$pod_statuses" ]; then 
            expected_pod_count=$desired_replicas
            actual_pod_count=$(echo -n "$pod_statuses" | wc -l) 
            running_pod_count=$(echo -n "$pod_statuses" | grep -c "Running")

            if [ "$actual_pod_count" -eq "$expected_pod_count" ] && [ "$running_pod_count" -eq "$expected_pod_count" ]; then
                echo "All $running_pod_count pods are in Running state."
                exit 0 
            else
                echo "Waiting for all $expected_pod_count pods to be in Running state (Currently $running_pod_count/$actual_pod_count Running)..."
                all_pods_running=false 
            fi
        else 
             if [ "$desired_replicas" -eq "0" ]; then
                 echo "Deployment scaled to 0 replicas as expected (no pods found)."
                 exit 0 
             fi
        fi

    elif [ "$desired_replicas" -eq "0" ] && [ "$ready_replicas" -eq "0" ] && [ "$updated_replicas" -eq "0" ]; then
        echo "Deployment '$DEPLOYMENT_NAME' is scaled to 0 replicas as expected."
        exit 0
    fi
    
    sleep $INTERVAL_SECONDS
    elapsed_time=$((elapsed_time + INTERVAL_SECONDS))
    echo "Elapsed time: $elapsed_time seconds..."
done

echo "Timeout! Deployment '$DEPLOYMENT_NAME' did not become fully ready and updated within $TIMEOUT_SECONDS seconds."
echo "Final status: Desired=$desired_replicas, Updated=$updated_replicas, Ready=$ready_replicas"

$KUBECTL_CMD get pods -l "app=$APP_LABEL"
exit 1