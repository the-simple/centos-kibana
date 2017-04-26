FROM centos:7

MAINTAINER Aleksandr Lykhouzov <lykhouzov@gmail.com>

RUN rpm --import https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7;\
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm; \
#Main installation
rpm --import http://packages.elastic.co/GPG-KEY-elasticsearch; \
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch; \
yum -y install  java-1.8.0-openjdk;\
export JAVA_HOME=/usr/lib/jvm/jre-openjdk;\
echo $'[kibana-5.x]\n\
name=Kibana repository for 5.x packages\n\
baseurl=https://artifacts.elastic.co/packages/5.x/yum\n\
gpgcheck=1\n\
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch\n\
enabled=1\n\
autorefresh=1\n\
type=rpm-md\n\
' | tee /etc/yum.repos.d/kibana.repo; \
yum install -y kibana \
&& yum clean all \
# change configuration
&& sed -i 's/# server.host: "0.0.0.0"/server.host: "localhost"/g' /etc/kibana/kibana.yml \
&& groupadd -r docker && useradd -r -g docker docker
EXPOSE 5601
ENV JAVA_HOME=/usr/lib/jvm/jre-openjdk
CMD ["/usr/share/kibana/bin/kibana"]
