FROM zabbix/zabbix-server-mysql:centos-latest

LABEL org.label-schema.schema-version="1.0" \
    org.label-schema.name="Zabbix Server Docker Image" \
    org.label-schema.vendor="AlleoTech" \
    org.label-schema.livence="MIT" \
    org.label-schema.build-data="2019051301"

MAINTAINER AlleoTech <admin@alleo.tech>

ARG PHP_VERSION=71

# Install EPEL & REMI
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
    && rpm -Uvh http://rpms.remirepo.net/enterprise/remi-release-7.rpm \
    && yum-config-manager --enable epel \
    && yum-config-manager --enable remi-php${PHP_VERSION}

# Install PHP and Tools 
RUN yum -y install --setopt=tsflags=nodocs git \
    openssl \
    openssh-clients \
    php-cli \
    php-common \
    php-gd \
    php-intl \
    php-json \
    php-ldap \
    php-mbstring \
    php-mcrypt \
    php-mysqlnd \
    php-opcache \
    php-pdo \
    php-pecl-apcu \
    php-process \
    php-soap \
    php-xml \
    php-xmlrpc \
    python-pip \
    && yum clean all \
    && rm -rf /var/cache/yum

# Install awscli
RUN pip install awscli

# Configure PHP
RUN sed -i -e 's~^;date.timezone =$~date.timezone = UTC~g' /etc/php.ini

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["docker-entrypoint.sh"]
