#! /bin/bash

# install Kubectl CLI
install_KubectlCli() {
  # add Kube config
  if [[ ! -d ~/.kube ]]; then
    mkdir ~/.kube
    echo -n "directory created..."
  fi

  # Write credentials to ~/.kube/config
  if [[ ! -z $INTKUBE_INTEGRATION_MASTERKUBECONFIGCONTENT ]]; then
    # from Shippable Kubernetes account integration specified as input to job
    echo "kube config created from shippable integration"
    echo "$INTKUBE_INTEGRATION_MASTERKUBECONFIGCONTENT" > ~/.kube/config
  else
    # from S3 bucket
    aws s3 cp s3://clusters.example-kube-cluster.com/config ~/.kube/config
  fi

  # install Kubernetes CLI
  if [[ ! $(which kubectl) ]]; then
    echo -n "installing kubectl CLI..."
    curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
    chmod +x ./kubectl
    sudo mv ./kubectl /usr/local/bin/kubectl
    if [[ $(which kubectl) ]]; then
      echo "kubectl CLI installed successfully"
    fi
  fi
}
