> Use this file to gather the content required for the pattern overview. Copy this draft-patten-template.md file, replace with your own content for each of the sections below, and attach your file to the GitHub tracking issue for your pattern.

> For full details on requirements for each section, see "Write a code pattern overview" on w3 Developer: [https://w3.ibm.com/developer/documentation/write-code-pattern-overview/](https://w3.ibm.com/developer/documentation/write-code-pattern-overview/)

# Short title

> Provide a suggested short title with a maximum of 10 words. The short title must start with a task- or goal-oriented verb; for example, "Build" "Create" "Detect" "Analyze" "Implement" "Write". You can include technologies (e.g. "blockchain"), but no product names.

Build a Service Mesh for Microservices in the Cloud

# Long title

> Expand on the short title, focusing on open source or generic tools and programs. Include IBM product names only if that product is required in the pattern and cannot be substituted.

Building an Istio 1.6 Service Mesh for Bee Travels, a Microservices Based Application Deployed on Kubernetes

# Author

> Provide names and IBM email addresses.

* Grace Kim <gracekim@ibm.com>

# URLs

### Github repo

> "Get the code": Provide the link to GitHub repo for the code.

* https://github.com/IBM/bee-travels-istio.git

# Summary

> Expand on the long-title and provide context; This summary of the pattern will help the audience decide whether they should keep reading. The summary will be used to create the meta-description and excerpt, so be concise (2-3 sentences) and use keywords throughout.

> *Write 2-3 short sentences.*

This code pattern will focus on deploying a travel booking microservices application to Kubernetes and creating a service mesh with Istio 1.6. Kubernetes allows for containerization of the application and Istio provides a means to connect, control, and monitor the microservice interactions across containers.

# Technologies

> Provide the broad categories of technology used or demonstrated in your pattern. IBM Developer uses a standard list of essential and trending technologies identified by OMs, editors, and stakeholders. The first technology that you list will be considered the primary technology.

> To view all components see [https://developer.ibm.com/technologies/](https://developer.ibm.com/technologies/).

* Microservices
* Containers

# Description

> Tell the story of your code pattern: describe the problem and who might encounter it; why is your pattern the right way to overcome the challenge? Highlight interesting code features and wherever possible, describe real-world situations where a developer will benefit from using the pattern. DO NOT include detailed technical steps, instructions, and commands; they will be provided in the readme file for your code.

> *Write 3-4 paragraphs.*

Bee Travels is a conceptual travel booking web application designed to demonstrate a microservices architecture. Microservices allow an application to be broken up into smaller, independent services that can be developed, deployed, and maintained individually. This separation provides many advantages including targeted scalability, improved fault isolation, and use of a customizable technology stack. However, microservices can be difficult to manage without a service mesh.

Istio is an open-source service mesh platform that provides a way to connect, control, and monitor microservice interactions. The service mesh takes care of traffic management once the rules have been configured and provides mesh observability through the telemetry it collects. 

This code pattern will focus on the following 5 microservices of the Bee Travels application:
* UI
* Destination
* Hotel
* Car Rental
* Currency Exchange

Currently, there are 2 version of the destination, hotel, and carrental services. Version 1 stores data locally and version 2 accesses data from an external database. In this code pattern, we will route and shift traffic to specific versions of the services and observe the traces and metrics to analyze latency.

# Flow

> Provide a draft architecture diagram followed by the flow steps; the architecture diagram needs to show a complete set of people, components, and technologies covered by your pattern; add numbers to the diagram that correspond with the written flow steps. The flow steps provide the  details of what happens at each stage, and the tasks performed by each component or technology; these are not steps to reproduce the code, but a description of the architecture of the code.

> Upload a draft architecture diagram to this issue. Remember to include numbers in the diagram to represent the flow steps that you provide below the diagram. A graphic designer will use your draft to create the production-ready image.

1. Flow step 1
2. Flow step 2
3. Flow step 3

# Instructions

> Provide the high-level technical steps that a developer will complete in the pattern (the details for these steps will appear in the readme file). For example, if the developer needs to install and configure a program, step one might be "Download the code from GitHub" and step 2 might be "Configure the code on your local drive." You would provide the full technical details on how to configure the code in the readme file.

> Find the detailed steps for this pattern in the [readme file](<URL for the README.md file in your GitHub repo>). The steps will show you how to:

1. Complete the prerequisite IBM Cloud set-up
2. Clone the repository
3. Deploy the application to Kubernetes
4. Configure the Istio service mesh

# Components and services

> List all components and services that play a prominent role in your pattern. Components are IBM products, any open source project, or solutions that are NOT IBM Cloud Services. Services are services available in the IBM Cloud (public) Catalog.

> To view all components see [http://developer.ibm.com/components](http://developer.ibm.com/components).

> To view services, see [https://console.bluemix.net/catalog/](https://console.bluemix.net/catalog/)

* Kubernetes
* Istio

# Runtimes

> Indicate languages or environments your pattern code requires, if applicable. (java, javascript/node, .net, swift, go, php, python, ruby, etc.)

* NodeJS

# Related IBM Developer content

> List any IBM Developer resources that are closely related to this pattern, such as other patterns, blog posts, tutorials, etc..

* [Intro to Istio](https://developer.ibm.com/videos/intro-to-istio-webcast/)
* [Deep dive into Istio](https://developer.ibm.com/videos/deep-dive-into-istio/)

