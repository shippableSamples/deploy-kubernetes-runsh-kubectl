#! /bin/bash -e

echo "deploying to Kubernetes cluster..."

# set context for Kube deployment
kubectl config use-context $CLUSTER

# remove any prior/sample deploySpecs
if [[ -d $GIT_REPO_PATH/gitRepo/pipeline/deploySpecs ]]; then
  rm $GIT_REPO_PATH/gitRepo/pipeline/deploySpecs/*.yaml
fi

# for each yaml template, generate an updated deploySpec
ENVIRONMENT=$(echo "$ENVIRONMENT" | awk '{print tolower($0)}')
echo "preparing kubernetes yaml files for "$ENVIRONMENT
for file in $GIT_REPO_PATH/gitRepo/pipeline/deployTemplates/*.yaml; do
  TEMPLATE=$file
  baseFile=${file##*/}
  deploymentName=${baseFile%.yaml}-$ENVIRONMENT
  DEST=$(echo $deploymentName | sed 's/-template//')
  envsubst < $TEMPLATE > $GIT_REPO_PATH/gitRepo/pipeline/deploySpecs/$DEST.yaml
done;

# for each deploySpec, execute deployment to Kube cluster
for file in $GIT_REPO_PATH/gitRepo/pipeline/deploySpecs/*.yaml; do
  echo "processing "$file
  baseFile=${file##*/}
  deploymentName=${baseFile%.yaml}
  kubectl apply -f $file --record
  # STATUS=""
  # while [[ "$STATUS" != *"successfully rolled out"* ]]; do
  #   STATUS=$(kubectl rollout status deployments $deploymentName)
  #   echo -e $STATUS"\n"
  #   sleep 1
  # done
done;

# # save State to be used in subsequent jobs or next time this job runs. Pass variable names or files (with path) as parameters
save_state_variables SAMPLE_IMAGE_URL SAMPLE_IMAGE_TAG 
save_state_files /build/IN/shipdemo-img/version.json
