This project will spin up a Vagrant box and install trackr into it.

Here's how to get started (make sure you have a recent version of [Vagrant](https://www.vagrantup.com/) installed):

    git clone https://github.com/techdev-solutions/trackr-vagrant.git
    cd trackr-vagrant/
    vagrant up

The provisioning will take a good deal of time, so grab yourself a hot beverage and read on..

Building on a Ubuntu base box, the provisioner will install some system tools and a fresh Java 8.
It will check out [the backend](https://github.com/techdev-solutions/trackr-backend) and [the frontend](https://github.com/techdev-solutions/trackr-frontend) and build both of them.

The backend will run on a Tomcat 8 (you can access the manager app using login `trackr:trackr`).
While the frontend will be served from NGINX.

Once the provisioner has finished you can access trackr at http://localhost:9090
