#Phabricator (https://phabricator.org/)

FROM phusion/baseimage:0.9.11

# Ensure UTF-8
RUN locale-gen en_US.UTF-8

RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y upgrade

# Disable SSH (Not using it at the moment).
RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh

# Basic Requirements
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install mariadb-client nginx php5 php5-fpm php5-mysql php-apc pwgen inotify-tools python-setuptools curl git unzip sendmail

# Wordpress Requirements
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install php5-curl php5-gd php5-intl php-pear php5-imagick php5-imap php5-mcrypt php5-memcache php5-ming php5-ps php5-pspell php5-recode php5-sqlite php5-tidy php5-xmlrpc php5-xsl php5-cli php5-json php5-ldap

# Install VCS binaries (git, mercurial, subversion) to pull sources and for phabricator use
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y git subversion mercurial

# Add startup script
ADD ./startup.sh /opt/startup.sh
RUN chmod +x /opt/startup.sh

RUN mkdir /etc/service/phabricator-garbage
ADD phabricator.sh /etc/service/phabricator-garbage/run
RUN chmod +x /etc/service/phabricator-garbage/run

RUN mkdir /etc/service/phabricator-repo
ADD phabricator-repo.sh /etc/service/phabricator-repo/run
RUN chmod +x /etc/service/phabricator-repo/run

RUN mkdir /etc/service/phabricator-task1
ADD phabricator-task1.sh /etc/service/phabricator-task1/run
RUN chmod +x /etc/service/phabricator-task1/run

RUN mkdir /etc/service/phabricator-task2
ADD phabricator-task2.sh /etc/service/phabricator-task2/run
RUN chmod +x /etc/service/phabricator-task2/run

RUN mkdir /etc/service/phabricator-task3
ADD phabricator-task3.sh /etc/service/phabricator-task3/run
RUN chmod +x /etc/service/phabricator-task3/run

RUN mkdir /etc/service/phabricator-task4
ADD phabricator-task4.sh /etc/service/phabricator-task4/run
RUN chmod +x /etc/service/phabricator-task4/run

RUN mkdir /etc/service/nginx
ADD nginx.sh /etc/service/nginx/run
RUN chmod +x /etc/service/nginx/run

RUN mkdir /etc/service/php5-fpm
ADD fpm.sh /etc/service/php5-fpm/run
RUN chmod +x /etc/service/php5-fpm/run

# Set timezone
RUN echo "America/Chicago" > /etc/timezone; dpkg-reconfigure -f noninteractive tzdata

# nginx config
RUN sed -i -e"s/keepalive_timeout\s*65/keepalive_timeout 2/" /etc/nginx/nginx.conf
RUN sed -i -e"s/keepalive_timeout 2/keepalive_timeout 2;\n\tclient_max_body_size 100m/" /etc/nginx/nginx.conf
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# php-fpm config
RUN sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php5/fpm/php.ini
RUN sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" /etc/php5/fpm/php.ini
RUN sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 100M/g" /etc/php5/fpm/php.ini
RUN sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf
RUN sed -i -e "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" /etc/php5/fpm/pool.d/www.conf
RUN find /etc/php5/cli/conf.d/ -name "*.ini" -exec sed -i -re 's/^(\s*)#(.*)/\1;\2/g' {} \;

# nginx site conf
ADD ./phabricator.conf /etc/nginx/sites-available/default

RUN cd /opt/ && git clone https://github.com/facebook/libphutil.git
RUN cd /opt/ && git clone https://github.com/facebook/arcanist.git
RUN cd /opt/ && git clone https://github.com/facebook/phabricator.git

RUN mkdir -p /var/repo/

RUN ulimit -c 10000

# Clean packages
RUN apt-get clean

VOLUME /opt/phabricator/conf/local
EXPOSE 80

CMD ["/opt/startup.sh"]
