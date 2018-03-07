#!/bin/bash
export LANGUAGE="en_US.UTF-8"
echo "LANGUAGE="en_US.UTF-8"" | sudo tee --append /etc/default/locale
echo "LC_ALL="en_US.UTF-8"" | sudo tee --append /etc/default/locale

sudo apt-get update
sudo apt-get dist-upgrade -y

# Zammad requirements
sudo apt-get install -y curl git-core patch build-essential bison zlib1g-dev libssl-dev libxml2-dev libxml2-dev sqlite3 libsqlite3-dev autotools-dev libxslt1-dev libyaml-0-2 autoconf automake libreadline6-dev libyaml-dev libtool libgmp-dev libgdbm-dev libncurses5-dev pkg-config libffi-dev libmysqlclient-dev nginx gawk

# MySQL
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password vagrant'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password vagrant'
sudo apt-get -y install mysql-server

# Postgres
sudo apt-get install postgresql postgresql-contrib libpq-dev -y
sudo pg_createcluster 9.5 main --start

# Ruby 2.4.2
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
curl -sSL https://get.rvm.io | bash -s stable --ruby=2.4.2
source ~/.rvm/scripts/rvm
gem install bundler

# Zammad
cd /opt/zammad
bundle install
rake db:create
rake db:migrate
rake db:seed

# to run rails
# rails s -p 9000 -b 0.0.0.0
