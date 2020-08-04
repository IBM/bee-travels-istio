<!-- Put badges at the very top -->
<!-- Change the repo -->
[![Build Status](https://travis-ci.org/IBM/watson-banking-chatbot.svg?branch=master)](https://travis-ci.org/IBM/watson-banking-chatbot)

# Building an Istio 1.6 Service Mesh for Bee Travels, a Microservices Based Application Deployed on Kubernetes

In this code pattern, we will deploy a microservices based application to  IBM Kubernetes Service and create a service mesh with Istio 1.6. 

When you have completed this code pattern, you will understand how to:

* Deploy a microservices application on Kubernetes
* Configure an Istio service mesh, including:
  * Install and configure the IBM Managed Istio add-on
  * Route traffic to specific microservice versions
  * Shift traffic between multiple microservice versions (A/B testing)
  * Access distributed trace spans through Jaeger
  * Analyze service traffic and latency through Grafana
  * Visualize the service mesh through Kiali
  * View access logs 
* Generate load tests with [Artillery](https://artillery.io/docs/)

<!--add an image in this path-->
![architecture](readme_images/v1.jpeg)
![architecture](readme_images/v2.jpeg)
![architecture](readme_images/v3.jpeg)

<!--Optionally, add flow steps based on the architecture diagram-->
## Flow

<!-- 1. Step 1.
2. Step 2.
3. Step 3.
4. Step 4.
5. Step 5. -->

# Prerequisites

* [NodeJS](https://nodejs.org/en/download/)
* [NPM](https://www.npmjs.com/get-npm)
* [Artillery](https://artillery.io/docs/getting-started/)

# Steps

1. [Complete the IBM Cloud set-up for Kubernetes and Istio](#1.-Complete-the-IBM-Cloud-set-up-for-Kubernetes-and-Istio)
2. [Clone the repositories](#2.-Clone-the-repositories)
3. [Deploy the application to Kubernetes](#3.-Deploy-to-Kubernetes)
   * Deploy version 1 (data stored locally)
   * Deploy version 2 (data stored in an in-cluster database)
   * Deploy version 3 (data stored in a database in the cloud)
   * Access the application (ingress gateway)
4. [Configure the Istio service mesh](#4.-Configure-the-Istio-service-mesh)
   * Route traffic to specific microservice versions
   * Shift traffic between multiple microservice versions
   * Access distributed trace spans through Jaeger
   * Analyze service traffic and latency through Grafana
   * Visualize the service mesh through Kiali
   * View access logs

## 1. Complete the IBM Cloud set-up for Kubernetes and Istio

1. [Sign up for an IBM Cloud account.](https://cloud.ibm.com/docs/account?topic=account-signup) if you do not have one. You must have a Pay-As-You-Go or Subscription account to deploy this code pattern. See [here](https://cloud.ibm.com/docs/account?topic=account-upgrading-account) to upgrade your account.

2. [Install the IBM Cloud CLI.](https://cloud.ibm.com/docs/cli?topic=cli-getting-started#idt-prereq)

3. [Provision a new Kubernetes cluster.](https://cloud.ibm.com/docs/containers?topic=containers-clusters#clusters_ui) Follow the steps to create a standard classic cluster.
   > NOTE: This may take up to 30 minutes.

4. When your cluster has been created, navigate to the **Add-ons** panel on the left side of your cluster console. Click **Install** for the Managed Istio Add-on.
![istio_addon](readme_images/cluster_addon_console.png)

5. After Istio has finished installing, [install the `istioctl` CLI.](https://cloud.ibm.com/docs/containers?topic=containers-istio#istioctl)

6. [Customize your Istio installation](https://cloud.ibm.com/docs/containers?topic=containers-istio#customize) by following steps 1 through 4 to enable monitoring and increase trace sampling to 100.
   > Your configmap should look like this:
![configmap](readme_images/configmap.png)

## 2. Clone the repositories

1. Clone the `bee-travels-istio` repository locally. In a terminal window, run:
   ```
   $ git clone https://github.com/IBM/bee-travels-istio.git
   ```

## 3. Deploy to Kubernetes

1. If you haven't already, log in to IBM Cloud using the command line.
   ```
   $ ibmcloud login
   ```

2. Set the cluster that you created as the context for this session.
   ```
   $ ibmcloud ks cluster config -c <cluster_name_or_ID>
   ```

3. Verify that `kubectl` commands run properly and that the Kubernetes context is set to your cluster.
   ```
   $ kubectl config current-context
   ```
   > Example output:
   ```
   <cluster_name>/<cluster_id>
   ```

4. Enable automatic Istio sidecar injection.
   ```
   $ kubectl label namespace default istio-injection=enabled
   ```

### Deploy version 1 (data stored in json flat files)

1. Navigate to the `bee-travels-istio` root directory and deploy the application with version 1 services:
   ```
   $ ./deploy-k8s-v1.sh
   ```

### Deploy version 2 (data stored in an in-cluster database)
> The following outlines specific steps to connect to an in-cluster MongoDB database, but the Bee Travels application also supports PostgreSQL, ClouchDB, and Cloudant.

1. Deploy the appication with version 2 services.
   ```
   $ ./deploy-k8s-v2.sh
   ```

2. foo
   ```
   $ kubectl get node -o wide
   ```

4. Note the `EXNTERNAL-IP` of the `mongo-lb` service.
   ```
   $ kubectl get svc mongo-lb
   ```

4. Run the following script to populate the database that was created.
   ```
   $ ./generate.sh
   ```

5. Answer the prompts as seen below. For the **Database Connection URL**, replace `EXTERNAL-IP` with the IP address from step 4. Repeat this step for the car and hotel services.
   > NOTE: This code pattern will not use the flights service.
   ```
   Welcome to the Bee Travels Data Generating Script
   Please answer the following options to configure your data:

   Destination Data (Y/N): y
      Generate Destination Data (Y/N): n
      Database (mongodb/postgres/couchdb/cloudant): mongodb
      Database Connection URL: mongodb://admin:admin@EXNTERNAL-IP:32508
      Use SSL/TLS (Y/N): n
   ```

6. Open `k8s/carrental-v2-deploy.yaml` in an editor. Set the `value` in line 41 to `mongodb://admin:admin@mongo-lb:27017`. Repeat this step for `k8s/destination-v2-deploy.yaml` and `k8s/hotel-v2-deploy.yaml`.


### Deploy version 3 (data stored in a database in the cloud)
> The following outlines specific steps to connect to a MongoDB database in the cloud, but the Bee Travels application also supports PostgreSQL, ClouchDB, and Cloudant.

1. [Provision a MongoDB deployment in the cloud.](https://cloud.ibm.com/catalog/services/databases-for-mongodb)

2. When your Mongo as a service deployment has been created, navigate to the **Manage** panel on the left side of your cluster console and click the **Settings** tab. Set a new password for your service connection.
![mongo_password](readme_images/mongo_password.png)

3. Navigate to the **Overview** tab and take note of the **Public mongo endpoint**.
![mongo_url](readme_images/mongo_url.png)

4. Scroll down and download the **TLS certificate**.
![mongo_certificate](readme_images/mongo_tls.png)

5. Run the following script to populate the database that was created.
   ```
   $ ./generate.sh
   ```

6. Answer the prompts as seen below. For the **Database Connection URL**, input the endpoint from Step 3 and replace `$USERNAME` with `admin` and `$PASSWORD` with the password  set in step 2. For the **Certificate File Path**, input the path to the TLS certificate downloaded in step 4. Repeat this step for the car and hotel services.
   > NOTE: This code pattern will not use the flight service.
   ```
   Welcome to the Bee Travels Data Generating Script
   Please answer the following options to configure your data:

   Destination Data (Y/N): y
      Generate Destination Data (Y/N): n
      Database (mongodb/postgres/couchdb/cloudant): mongodb
      Database Connection URL:
      Use SSL/TLS (Y/N): y
      Certificate File Path:
   ```

7. Open `k8s/carrental-v3-deploy.yaml` in an editor. Set the value in line 41 to the URL from step 3 and replace `$USERNAME` with `admin` and `$PASSWORD` with the password  set in step 2. Repeat this step for `k8s/destination-v3-deploy.yaml` and `k8s/hotel-v3-deploy.yaml`.

<!-- CONFIRM W MAX -->
8. Decode the contents of the TLS certificate from step 4 

9. Open `k8s/mongo-secret.yaml` in an editor. Set the `dbsecret` in line 7 to the content of the TLS certificate from step 4.

10. Deploy the appication with version 3 services.
   ```
   $ ./deploy-k8s-v3.sh
   ```

At this point, all 3 versions of the destination, hotel, and car rental services should be deployed, along with the UI and currency exchange services.

Confirm that the pods and services are up and running.
```
kubectl get po
```
<!-- SCREENSHOT -->
![po](readme_images/po.png)
and 
```
kubectl get svc
```
<!-- SCREENSHOT -->
![svc](readme_images/svc.png)

### Access the application (ingress gateway)

1. Create an ingress gateway so the application is accessbile from outside the cluster.
   ```
   $ kubectl apply -f istio/gateway.yaml
   ```

2. Access the application by navigating to the IP address defined in `EXTERNAL-IP` of the ingress gateway in the browser.
   ```
   $ kubectl get svc -n istio-system istio-ingressgateway
   ```

3. Prepare to generate traffic using the Artillery script by opening `artillery_load/artillery.yaml` in an editor. Replace `EXTERNAL-IP` in line 2 with the IP address from step 2.

## Configure the Istio service mesh

1. We will use the Grafana dashboard to track traffic routing and traffic shifting. [Set up your Grafana credentials with a secret.](https://cloud.ibm.com/docs/containers?topic=containers-istio-health#grafana)

2. Access the Grafana dashboard by running the following command. The dashboard should launch in a browser window automatically, but if it does not, navigate to `localhost:50340`.
   ```
   $ istioctl dashboard grafana
   ```

<!-- SCREENSHOT -->
3. Click the **Home** dropdown and select the **Istio Mesh Dashboard**. You should see a list of all of the services in your cluster.
   ![grafana-home](readme_images/grafana-home.png)
   ![grafana-menu](readme_images/grafana-menu.png)
   ![grafana-mesh](readme_images/grafana-mesh.png)

### Route traffic to specific microservice versions

1. Before we can set traffic rules, destination rules must to be defined for Istio to identify the service versions available in the application. These different versions are referred to as subsets.
   ```
   $ kubectl apply -f istio/destinationrules.yaml
   ```

2. Confirm that the destination rules have been created.
   > Note the *subset* field for each service.  
   ```
   $ kubectl get dr -o yaml
   ```

3. We will first route all traffic to the `v1` services by applying a set of virtual service rules. Virtual services route traffic to the defined configuration.
   ```
   $ kubectl apply -f istio/virtualservice-all-v1.yaml
   ```

4. Confirm that the `v1` virtual service rules have been applied.
   > Note the *subset* value for each service's destination is set to `v1`.
   ```
   $ kubectl get vs -o yaml
   ```

5. Generate traffic to the application using the Artillery script.
   > Before running, ensure that you have updated the `artillery.yaml` file with the correct IP address for your cluster, as described above.
   ```
   $ artillery run artillery_load/artillery.yaml
   ```

<!-- SCREENSHOT -->
6. Navigate to the Grafana dashboard. Note how all of the traffic has been routed to `v1` services. 
![grafana-v1](readme_images/grafana-v1.png)

7. Remove the `v1` virtual service rules.
   ```
   $ kubectl delete -f istio/virtualservice-all-v1.yaml
   ```

8. We will now route all traffic to the `v2` services by applying a new set of virtual service rules.
   ```
   $ kubectl apply -f istio/virtualservice-all-v2.yaml
   ```

9. Confirm that the `v2` virtual service rules have been applied.
   > Note the *subset* value for each service's destination is set to `v2`.
   ```
   $ kubectl get vs -o yaml
   ```

10. Generate traffic to the application using the Artillery script.
      ```
      $ artillery run artillery_load/artillery.yaml
      ```

<!-- SCREENSHOT -->
11. Navigate to the Grafana dashboard. Now note how all of the traffic has been routed to `v2` services. 
![grafana-v2](readme_images/grafana-v2.png)

12. Remove the `v2` virtual service rules. 
      ```
      $ kubectl delete -f istio/virtualservice-all-v2.yaml
      ```

13. Feel free to write and apply your own set of `v3` virtual service rules or try applying `istio/virtualservice-all-v3.yaml` on your own.
      > Remember to delete your virtual service rules before moving on.

### Shift traffic between multiple microservice versions

1. We will first define virtual service rules to shift traffic evenly between `v1` and `v3` services. Traffic shifting is also referred to as weight-based routing and is helpful for A/B testing. 
   ```
   $ kubectl apply -f istio/virtualservice-weights.yaml
   ```

2. Confirm that the virtual service rules have been applied.
   > Note the *weight* value for the two `v1` and `v3` destinations of each service is set to `50`.
   ```
   $ kubectl get vs -o yaml
   ```

3. Generate traffic to the application using the Artillery script.
   ```
   $ artillery run artillery_load/artillery.yaml
   ```

<!-- SCREENSHOT -->
4. Navigate to the Grafana dashboard. Note how traffic is split between `v1` and `v3` services.
![grafana-50](readme_images/grafana-50.png)

5. Remove the virtual service rules. 
   ```
   $ kubectl delete -f istio/virtualservice-weights.yaml
   ``` 

6. We will now shift traffic to the `v1`, `v2`, and `v3` services at 10%, 30%, and 60%, respectively.
   ```
   $ kubectl apply -f istio/virtualservice-all.yaml
   ```

7. Confirm that the virtual service rules have been applied.
   > Note the *weight* value for the `v1`, `v2`, `v3` destinations of each service are set to `10`, `30`, and `60`.
   ```
   $ kubectl get vs -o yaml
   ```

8. Generate traffic to the application using the Artillery script.
   ```
   $ artillery run artillery_load/artillery.yaml
   ```

<!-- SCREENSHOT -->
9. Navigate to the Grafana dashboard. Note how traffic is split between `v1`, `v2`, and `v3` services.
![grafana-all](readme_images/grafana-all.png)

10. Remove the virtual service rules. 
      ```
      $ kubectl delete -f istio/virtualservice-all.yaml
      ``` 

### Access distributed trace spans through Jaeger

[Jaeger](https://www.jaegertracing.io/docs/1.16/#about) is a platform to view distributed traces which shows the flow of information and can help isolate errors.

1. Access the Jaeger dashboard by running the following command. The dashboard should launch in a browser window automatically, but if it does not, navigate to `localhost:55545`.
   ```
   $ istioctl dashboard jaeger
   ```

<!-- SCREENSHOT -->
2. In a different browser tab, navigate to the Bee Travels application, enter a destination, and make a car rental request.
![car](readme_images/car.png)

<!-- SCREENSHOT -->
3. In Jaeger, select `carrental.default` from the **Service** drop-down and click **Find traces**. The top trace should have 
![jaeger](readme_images/jaeger.png)

4. Click on the first result item to analyze the trace for the request you just made in the browser. 
   > The trace provides information about how long the entire request took to process (`duration`), what URL was called (`http.url`), which pod/service version processed it (`node_id`), and more. 

   ![trace](readme_images/jaeger-trace.png)

### Analyze service traffic and latency through Grafana

[Grafana](https://grafana.com/grafana/) is a monitoring platform that proivdes details about the service mesh through a variety of dashboards:

* Mesh Dashboard provides an overview of all services in the mesh.
* Service Dashboard provides a detailed breakdown of metrics for a service.
* Workload Dashboard provides a detailed breakdown of metrics for a workload.
* Performance Dashboard monitors the resource usage of the mesh.
* Control Plane Dashboard monitors the health and performance of the control plane.

We have used the Mesh Dashboard to observe traffic in the service mesh. We will now take a look at the latency of the different services.

1. Access the dashboard if it is not yet running. 
   ```
   $ istioctl dashboard grafana
   ```

2. Generate traffic to the application using the Artillery script.
   ```
   $ artillery run artillery_load/artillery.yaml
   ```

<!-- SCREENSHOT -->
<!-- EXPLAIN P50, P90, P99 -->
3. DO SOME LATENCY ANALYSIS HERE
   ![grafana-latency](readme_images/grafana-latency)

### Visualize the service mesh through Kiali

[Kiali](https://kiali.io/documentation/latest/features/) is a visual representation of the service mesh and its configurations. It includes a topology graph and provides an interface to view the different components of the mesh.

1. [Set up your Kiali credentials with a secret.](https://istio.io/latest/docs/tasks/observability/kiali/#create-a-secret)

2. Access the Kiali dashboard by running the following command. The dashboard should launch in a browser window automatically, but if it does not, navigate to `localhost:55619/kiali`.
   ```
   $ istioctl dashboard kiali
   ```

3. WRITE

### View access logs

<!-- CHECK INFO -->
Envoy proxies can provide access information about the requests that the pod makes. 

1. [Enable access logging](https://cloud.ibm.com/docs/containers?topic=containers-istio#customize) by following steps 1 through 4 and adding `istio-global-proxy-accessLogFile: "/dev/stdout"` to the `data` section of the configmap. 
   > Your configmap should look like this:
![configmap_logs](readme_images/configmap_logs.png)

2. Restart all of the pods to finish enabling access logs.
   ```
   $ kubectl delete po --all
   ```

3. Display a list of all of the pods and note the name of the bee-ui pod. Use the pod name to start the access logs for the `bee-ui` pod's Envoy proxy.
   ```
   $ kubectl get po
   $ kubectl logs -f <bee-ui-pod-name> istio-proxy
   ```

<!-- SCREENSHOT -->
4. Navigate to the application in the browser, enter a destination, and make a hotel request. The access log should display the request and how it was routed.
![hotel](readme_images/hotel.png)
![logs](readme_images/logs.png)

<!-- template -->
# Troubleshooting

* Can I check if I have any issues with my Istio configuration?
   * The `istioctl analyze --all-namespaces` command can detect possible issues within your cluster. You can also run the command against one or multiple configuration files to analyze the effect of applying them to your cluster: `istioctl analyze istio/new-virtualservices.yaml`

* I'm running a load test with Artillery but only the `bee-ui` service is receiving traffic on Grafana.
   * Check to see that the `target` value in `artillery_load/artillery.yaml` does not have an extra `/` at the end of the address. (ex: "http://169.62.94.60")

<!-- keep this -->
## License

This code pattern is licensed under the Apache License, Version 2. Separate third-party code objects invoked within this code pattern are licensed by their respective providers pursuant to their own separate licenses. Contributions are subject to the [Developer Certificate of Origin, Version 1.1](https://developercertificate.org/) and the [Apache License, Version 2](https://www.apache.org/licenses/LICENSE-2.0.txt).

[Apache License FAQ](https://www.apache.org/foundation/license-faq.html#WhatDoesItMEAN)