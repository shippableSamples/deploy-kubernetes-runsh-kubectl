#! /bin/sh -e

# set path to the Git repo that holds the scripts
# path injected automatically by Shippable based on gitRepo resource as Input
# see http://docs.shippable.com/pipelines/jobs/runSh/#resource-variables
export GIT_REPO_PATH=$SHIPDEMOREPO_PATH

# source functions used in this script
for f in $GIT_REPO_PATH/gitRepo/pipeline/scriptFunctions/*.* ; do
  source $f ;
done

# install shell tools required
install_ShellTools

# install required CLIs
install_KubectlCli

# Leverage the environment variables that were automatically injected
# into the job environment by Shippable (i.e based on names of Inputs to the
# runSh jobs in shippable.job.yml).
# see http://docs.shippable.com/pipelines/jobs/runSh/#resource-variables

if [[ ! -z ${SHIPDEMOPARAMSTEST_PARAMS_ENVIRONMENT} ]]; then
  echo "preparing TEST environment variables..."
  export CLUSTER=$SHIPDEMOPARAMSTEST_PARAMS_CLUSTER
  export ENVIRONMENT=$SHIPDEMOPARAMSTEST_PARAMS_ENVIRONMENT
  export SAMPLE_PORT=$SHIPDEMOPARAMSTEST_PARAMS_PORT
  export SAMPLE_MEMORY=$SHIPDEMOPARAMSTEST_PARAMS_MEMORY
  export SAMPLE_CPU=$SHIPDEMOPARAMSTEST_PARAMS_CPUSHARES
  export SAMPLE_REPLICAS=$SHIPDEMOPARAMSTEST_PARAMS_REPLICAS
  export SAMPLE_IMAGE_URL=$SHIPDEMOIMG_SOURCENAME
  export SAMPLE_IMAGE_TAG=$SHIPDEMOIMG_VERSIONNAME

  elif [[ ! -z ${SHIPDEMOPARAMSPROD_PARAMS_ENVIRONMENT} ]]; then
    echo "preparing PROD environment variables..."
    export INCOMING_STATE_PATH=$SHIPDEMOKUBECTLDEPLOYTEST_PATH/runSh
    load_incoming_state_variables # load incoming state from prior job
    export CLUSTER=$SHIPDEMOPARAMSPROD_PARAMS_CLUSTER
    export ENVIRONMENT=$SHIPDEMOPARAMSPROD__PARAMS_ENVIRONMENT
    export SAMPLE_PORT=$SHIPDEMOPARAMSPROD_PARAMS_PORT
    export SAMPLE_MEMORY=$SHIPDEMOPARAMSPROD_PARAMS_MEMORY
    export SAMPLE_CPU=$SHIPDEMOPARAMSPROD_PARAMS_CPUSHARES
    export SAMPLE_REPLICAS=$SHIPDEMOPARAMSPROD_PARAMS_REPLICAS
    export SAMPLE_IMAGE_URL=$SAMPLE_IMAGE_URL_PREVIOUS
    export SAMPLE_IMAGE_TAG=$SAMPLE_IMAGE_TAG_PREVIOUS

  else echo "no environment variables loaded"
fi
