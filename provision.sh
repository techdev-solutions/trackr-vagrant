#!/bin/bash

install_dependencies() {
  echo 'installing dependencies...'
  cd /home/vagrant/
  sudo apt-get update
  curl -sL https://deb.nodesource.com/setup | sudo bash -
  sudo add-apt-repository -y ppa:webupd8team/java
  sudo apt-get update
  sudo apt-get install -y git nginx nodejs unzip
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
  sudo apt-get install -y oracle-java8-installer oracle-java8-set-default
  wget https://services.gradle.org/distributions/gradle-2.2.1-bin.zip
  unzip gradle-2.2.1-bin.zip
  sudo chown -R vagrant:vagrant gradle-2.2.1/
}

clone_backend() {
  echo 'cloning backend...'
  cd /home/vagrant/
  git clone https://github.com/techdev-solutions/trackr-backend.git
  sudo chown -R vagrant:vagrant trackr-backend/
}

build_backend() {
  echo 'building backend...'
  cp /vagrant_share/application_dev.properties /home/vagrant/trackr-backend/src/main/resources/
  cd /home/vagrant/trackr-backend/
  export GRADLE_OPTS="-Xmx512m"
  su vagrant -c "/home/vagrant/gradle-2.2.1/bin/gradle build"
}

setup_tomcat() {
  echo 'setting up tomcat...'
  cd /home/vagrant/
  wget http://archive.apache.org/dist/tomcat/tomcat-8/v8.0.15/bin/apache-tomcat-8.0.15.tar.gz
  tar -xzvf apache-tomcat-8.0.15.tar.gz
  sudo chown -R vagrant:vagrant apache-tomcat-8.0.15/
  cp /vagrant_share/tomcat-users.xml /home/vagrant/apache-tomcat-8.0.15/conf/
  cp /vagrant_share/setenv.sh /home/vagrant/apache-tomcat-8.0.15/bin/
  rm -r /home/vagrant/apache-tomcat-8.0.15/webapps/ROOT/
  mv /home/vagrant/trackr-backend/build/libs/trackr-1.0_0.war /home/vagrant/trackr-backend/build/libs/ROOT.war
  cp /home/vagrant/trackr-backend/build/libs/ROOT.war /home/vagrant/apache-tomcat-8.0.15/webapps/
}

clone_frontend() {
  echo 'cloning frontend...'
  cd /home/vagrant/
  git clone https://github.com/techdev-solutions/trackr-frontend.git
  sudo chown -R vagrant:vagrant trackr-frontend/
}

build_frontend() {
  echo 'building frontend...'
  cd /home/vagrant/trackr-frontend/
  sudo npm update
  sudo npm install -g grunt-cli bower karma
  su vagrant -c "grunt dist"
  su vagrant -c "bower install --config.interactive=false"
}

setup_nginx() {
  echo 'setting up nginx proxy...'
  cp /vagrant_share/trackr.conf /etc/nginx/sites-available/
  cp /vagrant_share/nginx.conf /etc/nginx
  rm /etc/nginx/sites-enabled/default
  ln -s /etc/nginx/sites-available/trackr.conf /etc/nginx/sites-enabled/
}

start_trackr() {
  echo 'starting trackr...'
  sudo nginx
  su vagrant -c "/home/vagrant/apache-tomcat-8.0.15/bin/startup.sh"
}

install_dependencies
clone_backend
build_backend
setup_tomcat
clone_frontend
build_frontend
setup_nginx
start_trackr
