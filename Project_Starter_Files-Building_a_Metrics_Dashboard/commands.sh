# Open a Powershell session
cd  D:\repo\udacity\udacity_nd064_C4_Observability_Starter_Files\Project_Starter_Files-Building_a_Metrics_Dashboard\
vagrant up
vagrant ssh

## set a kubectl context to support several clusters with your kubeconfig file

# set kubectl context: https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/
# set access to multiple clusters: https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/#set-the-kubeconfig-environment-variable
# create a context-file in dir config
mkdir config
vi config/dev-udacity

'''
apiVersion: v1
kind: Config
preferences: {}

clusters:
- cluster:
  name: development
- cluster:
  name: test

users:
- name: developer
- name: tester

contexts:
- context:
  name: dev-observability
- context:
  name: test-observability
'''

# example of setting a config items manually for a new cluster in config file
'''
kubectl config --kubeconfig=config-demo set-context dev-observability --cluster=development --namespace=dev-observability --user=developer
kubectl config --kubeconfig=config-demo set-context test-observability --cluster=test --namespace=test-observability --user=developer
'''
kubectl config --kubeconfig=config/dev-udacity view

sudo kubectl config --kubeconfig=config/dev-udacity use-context dev-observability
'''
vagrant@localhost:~> sudo kubectl config --kubeconfig=config/dev-udacity use-context dev-observability
Switched to context "dev-observability".
'''
## apply installations requried

# helm 3
sudo zypper in git
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# grafana/prometheus
kubectl create namespace monitoring
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
# helm repo add stable https://kubernetes-charts.storage.googleapis.com # this is deprecated
helm repo add stable https://charts.helm.sh/stable
helm repo update
helm install prometheus prometheus-community/kube-prometheus-stack --namespace monitoring --kubeconfig /etc/rancher/k3s/k3s.yaml

# jaeger
kubectl create namespace observability
# Please use the latest stable version
export jaeger_version=v1.28.0
kubectl create -f https://raw.githubusercontent.com/jaegertracing/jaeger-operator/${jaeger_version}/deploy/crds/jaegertracing.io_jaegers_crd.yaml
kubectl create -n observability -f https://raw.githubusercontent.com/jaegertracing/jaeger-operator/${jaeger_version}/deploy/service_account.yaml
kubectl create -n observability -f https://raw.githubusercontent.com/jaegertracing/jaeger-operator/${jaeger_version}/deploy/role.yaml
kubectl create -n observability -f https://raw.githubusercontent.com/jaegertracing/jaeger-operator/${jaeger_version}/deploy/role_binding.yaml
kubectl create -n observability -f https://raw.githubusercontent.com/jaegertracing/jaeger-operator/${jaeger_version}/deploy/operator.yaml

kubectl create -f https://raw.githubusercontent.com/jaegertracing/jaeger-operator/${jaeger_version}/deploy/cluster_role.yaml
kubectl create -f https://raw.githubusercontent.com/jaegertracing/jaeger-operator/${jaeger_version}/deploy/cluster_role_binding.yaml

# Deploy the application
# mount the host fs attached to dir /vagrant
cd /vagrant
cd manifests
kubectl apply -f app/
'''
deployment.apps/backend-app created
service/backend-service created
deployment.apps/frontend-app created
service/frontend-service created
deployment.apps/trial-app created
service/trial-service created
'''

# test grafana access by opening a new Powershell window each time
cd  D:\repo\udacity\udacity_nd064_C4_Observability_Starter_Files\Project_Starter_Files-Building_a_Metrics_Dashboard\
vagrant ssh
kubectl --namespace monitoring port-forward svc/prometheus-grafana --address 0.0.0.0 3000:80

# test app access by opening a new Powershell window each time
cd  D:\repo\udacity\udacity_nd064_C4_Observability_Starter_Files\Project_Starter_Files-Building_a_Metrics_Dashboard\
vagrant ssh
kubectl port-forward svc/frontend-service --address 0.0.0.0 8080:8080

## README Task 1
## Verify the monitoring installation
# *TODO:* run `kubectl` command to show the running pods and services for all components. Take a screenshot of the output and include it here to verify the installation
kubectl get svc,pods --all
# Done: File kubectl_all_svc_pods.png attached

## README Task 2
## Setup the Jaeger and Prometheus source
# *TODO:* Expose Grafana to the internet and then setup Prometheus as a data source. Provide a screenshot of the home page after logging into Grafana.
# Done File Grafana_homepage attached

## README Task 3
## Create a Basic Dashboard
# *TODO:* Create a dashboard in Grafana that shows Prometheus as a source. Take a screenshot and include it here.
# Done File Grafana_basic_dashboard attached

## README Task 4
## Create a Basic Dashboard
# *TODO:* Create a dashboard in Grafana that shows Prometheus as a source. Take a screenshot and include it here.
# Done File Grafana_basic_dashboard attached

## README Task 5
## Describe SLO/SLI
# *TODO:* Describe, in your own words, what the SLIs are, based on an SLO of *monthly uptime* and *request response time*.
'''
SLO: *monthly uptime* SLI: *Number of UP counts/day*
SLO: *request response time*: SLI: *Response time of successfull HTTP requests 20x in ms*
'''
#
# README Task 6
## Creating SLI metrics.
# *TODO:* It is important to know why we want to measure certain metrics for our customer. Describe in detail 5 metrics to measure these SLIs.
'''
#### My 5 SLIs:
Goal Availablity 1: *Number of UP counts/day*
Goal Availablity 2: *The proportion of valid HTTP GET requests 2XX, 3XX, 4XX (except 429 rate limiting)/day per url*
Goal Errors 1: *Percentage of errors having processed requests per hour (HTTP requests 5XX).*
Goal Latency 1: *The porportion of valid HTTP GET requests that were faster than a given treshold*
Goal Reliability 1: *Total failure rate of a service per url (number of failure/total time in service)*
'''

# README Task 7
## Create a Dashboard to measure our SLIs
# *TODO:* Create a dashboard to measure the uptime of the frontend and backend services We will also want to measure 40x and 50x errors. Create a dashboard that show these values over a 24 hour period and take a screenshot.
# Done File Dashboard_svc_status_error_codes attached

# README Task 8
## Tracing our Flask App
# *TODO:*  We will create a Jaeger span to measure the processes on the backend. Once you fill in the span, provide a screenshot of it here. Also provide a (screenshot) sample Python file containing a trace and span code used to perform Jaeger traces on the backend service.

# README Task 9
## Jaeger in Dashboards
# *TODO:* Now that the trace is running, let's add the metric to our current Grafana dashboard. Once this is completed, provide a screenshot of it here.

# README Task 10
## Report Error
*TODO:* Using the template below, write a trouble ticket for the developers, to explain the errors that you are seeing (400, 500, latency) and to let them know the file that is causing the issue also include a screenshot of the tracer span to demonstrate how we can user a tracer to locate errors easily.

'''
TROUBLE TICKET

Name:

Date:

Subject:

Affected Area:

Severity:

Description:
'''

# README Task 11
## Creating SLIs and SLOs
*TODO:* We want to create an SLO guaranteeing that our application has a 99.95% uptime per month. Name four SLIs that you would use to measure the success of this SLO.

# README Task 12
## Building KPIs for our plan
*TODO*: Now that we have our SLIs and SLOs, create a list of 2-3 KPIs to accurately measure these metrics as well as a description of why those KPIs were chosen. We will make a dashboard for this, but first write them down here.

# README Task 13
## Final Dashboard
*TODO*: Create a Dashboard containing graphs that capture all the metrics of your KPIs and adequately representing your SLIs and SLOs. Include a screenshot of the dashboard here, and write a text description of what graphs are represented in the dashboard.
