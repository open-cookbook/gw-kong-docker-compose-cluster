# IMG
FROM centos:7

# WHO
MAINTAINER boxu@yvhai.com

# Install Basic
# RUN rm -rvf /etc/yum.repos.d/* \
    # && curl http://mirrors.163.com/.help/CentOS7-Base-163.repo -o /etc/yum.repos.d/CentOS7-Base-163.repo \
RUN date \
    && yum update -y \
    && ls -lhrt /etc/yum.repos.d/ \
    && yum install -y vim rsync screen sysstat \
    && yum install -y tree net-snmp-utils net-tools bind-utils iputils telnet lsof \
    && yum install -y openssh-server openssh-clients \
    && yum install -y sudo make which yum-utils \
    && yum clean all && rm -rf /var/cache/yum

# Install Spec

# Config
RUN pwd \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo -e "\nUseDNS no\nGSSAPIAuthentication no\n" >> /etc/ssh/sshd_config

# patch
# RUN yum install -y xx

# 创建用户
RUN groupadd -g 1000 foobar \
    && useradd -g foobar -u 1000 -s /bin/bash foobar \
    && echo "foobar ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/99-yh-foobar


# 接口
WORKDIR /project
# USER foobar
EXPOSE 22
VOLUME [ "/project", "/data"]


# clean


# CMD
ENTRYPOINT [ "/usr/sbin/init" ] 
