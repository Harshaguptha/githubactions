#!/bin/bash

set -e
#sudo yum install -y gettext
#which envsubst

check_last_output () {
    if [ $? -ne 0 ]
    then
        echo "$1"
        ./../../shared/auth/logout.sh
        exit 1
    fi
}

# Login to Cloud provider
./../../shared/auth/login.sh

TOTAL_TIME=0
SLEEP_TIME=60
WAIT_TIME=1200

#Checking nodes are in ready state or not
while [[ $(kubectl get nodes | grep -i notready) ]]; do
    echo "Nodes are Not in Ready state, wait until time out"
    sleep $SLEEP_TIME
    ((TOTAL_TIME=TOTAL_TIME+$SLEEP_TIME))
    if [[ $TOTAL_TIME -gt $WAIT_TIME ]]; then
        echo "TIMEOUT_ERROR"
        ./../../shared/auth/logout.sh
        exit 1
    fi
done


#Check gatekeeper-system namespace exists, if not create
OPA_GATEKEEPER_NAMESPACE="gatekeeper-system"
OPA_GATEKEEPER_DEPLOYMENT="gatekeeper-system"

echo "OPA gatekeeper deployment if any..."
helm list -n $OPA_GATEKEEPER_NAMESPACE

if [ $INSTALL_OPA_GATEKEEPER == true ]; then
    echo "Installing OPA gatekeeper..."
    helm repo add gatekeeper https://open-policy-agent.github.io/gatekeeper/charts
    helm repo update

    #List all the available versions
    echo "opa gatekeeper available versions..."
    helm search repo -l gatekeeper

    envsubst < custom-values.yaml > custom-values-detokenized.yaml
    helm upgrade --install $OPA_GATEKEEPER_DEPLOYMENT gatekeeper/gatekeeper --version ${OPA_VERSION} --values custom-values-detokenized.yaml -n $OPA_GATEKEEPER_NAMESPACE --create-namespace --atomic --wait

    echo "OPA Gatekeeper Installed successfully..."
    helm list -n $OPA_GATEKEEPER_NAMESPACE
    kubectl get pod -n $OPA_GATEKEEPER_NAMESPACE
else
    echo "Skip Installing OPA gatekeeper..."
fi

# Apply Policy if any defined
if [ $APPLY_OPA_GATEKEEPER_POLICY == true ]; then
      echo "Applying OPA Gatekeeper Policy..."
      #kustomize build . | kubectl apply -f -
      #kubectl apply -k .
      applyopapolicy () {
        echo "Applying OPA Gatekeeper Policy : $1"
        kubectl apply -f $1/template.yaml
        sleep 5
        kubectl apply -f $1/constraint.yaml
        #kubectl apply -f $1/$ENVIRONMENT/constraint.yaml
      }
      export -f applyopapolicy
      find ./policy/* -prune -type d -exec bash -c 'applyopapolicy "$0"' {} \;
else
       echo "Skip Apply OPA Gatekeeper Policy..."
fi

#Logout of cloud
./../../shared/auth/logout.sh
