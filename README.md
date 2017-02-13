![AyeAye](https://github.com/shippableSamples/node-build-push-docker-hub/blob/master/public/resources/images/captain.png)

# Docker Build, Continuous Integration, and Deployment to Kubernetes using Kubectl CLI for a Node JS application
[![Run Status](https://api.shippable.com/projects/5885ecca11c45a1000af5760/badge?branch=master)](https://app.shippable.com/projects/5885ecca11c45a1000af5760)
[![Coverage Badge](https://api.shippable.com/projects/5885ecca11c45a1000af5760/coverageBadge?branch=master)](https://app.shippable.com/projects/5885ecca11c45a1000af5760)


A simple Node JS application with unit tests and coverage reports using mocha
and istanbul.   

This repo demonstrates the following features:
* Set up serverless CI, i.e. on Shippable-provided infrastructure
* Set up CD pipelines for a Kubernetes cluster running on Amazon EC2
* Perform CI tests
* Perform docker build and push image to Docker Hub
* Automatically deploy image to TEST environment 
* Manually deploy image to PROD environment 
* Set up runSh job type in Shippable using `kubectl` CLI (for 
declarative deploy job, see [this sample project](https://github.com/shippableSamples/node-build-push-docker-hub-deploy-kubernetes))

## Run CI for this repo on Shippable
* Fork this repo into your source code account (e.g. GitHub)
* Create an account (or login) on [Shippable](www.shippable.com) with your SCM account
* Create an [integration](http://docs.shippable.com/integrations/imageRegistries/dockerHub/) on Shippable for your Docker Hub account
* Update the CI configuration in `shippable.yml` file with your integration names (see comments in file)
* Follow these [setup instructions](http://docs.shippable.com/ci/runFirstBuild/) to enable your forked repo for CI and run a build 

## Add Continuous Delivery pipelines to deploy to Kubernetes

* Create an integration for [Kubernetes](http://docs.shippable.com/integrations/containerServices/kubernetes/)
* All pipeline config is in `shippable.resources.yml` and `shippable.jobs.yml`. Check these files and update config wherever the comment asks you to replace with your specific values
* Follow instructions to add your [Continuous Deployment pipeline](http://docs.shippable.com/tutorials/pipelines/howToAddSyncRepos/)
* Right-click on the runSh job in the SPOG view named 'shipdemo-kubectl-deploy-test' and run the job
  * This demo uses custom scripting jobs called 'runSh' jobs in Shippable - [learn how moe about runSh jobs](http://docs.shippable.com/pipelines/jobs/runSh/) 
* Your app should be deployed to your Kubernetes cluster as a Test pod
* Follow instructions to [connect your Continuous Integration project to your Continuous Delivery pipelines](http://docs.shippable.com/tutorials/pipelines/connectingCiPipelines/)(for this demo, just uncomment the `trigger` integration in shippable.yml)
* Right-click on the runSh job in the SPOG view named 'shipdemo-kubectl-deploy-prod' and run the job to deploy to a Prod pod
* Make a change to your forked repo and commit to GitHub - watch your pipeline automatically execute CI with push to Docker Hub and automatic deployment to the Test environment in Kubernetes
* Then right-click to deploy the newest changes to the Prod environment

Your end-to-end pipeline is complete! Now, any change you make to the application will be deployed to your Kubernetes Test pod and be ready to manually deploy a Prod pod, as well.

### CI console screenshot
![CI Console Log](https://github.com/shippableSamples/node-dockerhub-runsh-kubernetes-kubectl/blob/master/public/resources/images/shipdemo-kubectl-ci-console.png)

### Kubernetes integration screenshot
![CI Integration View](https://github.com/shippableSamples/node-dockerhub-runsh-kubernetes-kubectl/blob/master/public/resources/images/shipdemo-int-kube.png)

### CD Pipeline SPOG screenshot
![CD Pipeline](https://github.com/shippableSamples/node-dockerhub-runsh-kubernetes-kubectl/blob/master/public/resources/images/shipdemo-kubectl-deploy.png)

#### Launch a Kubernetes cluster for this demo

Instructions for launching a Kubernetes cluster using KOPS:  
https://kubernetes.io/docs/getting-started-guides/kops/

Determine settings for your cluster:  
YOUR_CLUSTER_DOMAIN_NAME="your.cluster-name.com"  
YOUR_ZONE="your_aws_zone" # e.g. us-east-1c

Build the cluster configuration (replace the zone and cluster name with your values):
```
kops create cluster --zones=$YOUR_ZONE $YOUR_CLUSTER_DOMAIN_NAME 
```

Create the cluster in AWS:
```
kops update cluster $YOUR_CLUSTER_DOMAIN_NAME 
```

To add a Kube UI:
```
kubectl create -f https://raw.githubusercontent.com/kubernetes/kops/master/addons/kubernetes-dashboard/v1.4.0.yaml
kubectl proxy
```
Then navigate to http://127.0.0.1:8001/ui

Delete the cluster:
```
kops delete cluster $YOUR_CLUSTER_DOMAIN_NAME --yes
```

To add ability to pull images from private registry:  
https://kubernetes.io/docs/user-guide/images/#specifying-imagepullsecrets-on-a-pod
