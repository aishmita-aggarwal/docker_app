FROM phusion/passenger-ruby22

ENV HOME /root

CMD ["/sbin/my_init"]

RUN sudo apt-get update -y

RUN sudo apt-get install -y build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison libmysqlclient-dev libreadline-dev libcurl4-openssl-dev python-software-properties mysql-server mysql-client

RUN rm -f /etc/service/nginx/down

RUN rm /etc/nginx/sites-enabled/default

ADD nginx.conf /etc/nginx/sites-enabled/webapp.conf

RUN mkdir /home/app/webapp

ADD . /home/app/webapp

WORKDIR /home/app/webapp
RUN bundle install
RUN ["service", "mysql", "start"]
RUN ["RAILS_ENV=production", rake", "db:setup"]

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD 'passenger start -a 0.0.0.0 -p 3000 -d -e production'