#!/bin/sh

# # create the user for the mysql server
adduser mysql -D

# install the mysql server and intialize it
pkg add mariadb mariadb-server

# create run time directories and set the correct permissions and ownership
[ ! -d  /var/run/mysqld ]  && mkdir /var/run/mysqld
[ ! -d  /var/run/mysqld ]  && mkdir /var/log/mysql
chown -R mysql /var/run/mysqld
chown -R mysql /var/log/mysql
mysql_install_db
sleep 2
mysqld  &
sleep 2
 
 echo "Make sure that NOBODY can access the server without a password"
 
# Make sure that NOBODY can access the server without a password
mysql -e "UPDATE mysql.user SET Password = PASSWORD('admin') WHERE User = 'root'"

# Kill the anonymous users
mysql -e "DROP USER ''@'localhost'"

# Because our hostname varies we'll use some Bash magic here.
mysql -e "DROP USER ''@'$(hostname)'"

# Make our changes take effect
mysql -e "FLUSH PRIVILEGES"

echo "Finished stage 1. mariadb is installed"
