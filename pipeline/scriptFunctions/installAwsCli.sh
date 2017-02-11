#! /bin/bash

# install AWS CLI
install_AwsCli() {
  echo -n "installing AWS CLI..."

  # add AWS credentials
  if [[ ! -d ~/.aws ]]; then
    mkdir ~/.aws
  fi
  echo -e "[shippable]\naws_access_key_id=$INTAWS_INTEGRATION_AWS_ACCESS_KEY_ID\naws_secret_access_key=$INTAWS_INTEGRATION_AWS_SECRET_ACCESS_KEY" >> ~/.aws/credentials
  export AWS_DEFAULT_PROFILE=shippable

  # install Python and PIP if not installed
  if [[ ! $(which python) ]]; then
    sudo $INSTALL_CMD python
    curl -O https://bootstrap.pypa.io/get-pip.py
    sudo python get-pip.py
  fi

  # install AWS CLI
  if [[ ! $(which aws) ]]; then
    sudo $(which pip) install awscli
    if [[ $(aws help) ]]; then
      echo "AWS CLI installed successfully"
    fi
  fi
}
