#!/bin/bash

#Define variables
TOMCAT=apache-tomcat-7.0.59
TOMCAT_WEBAPPS=$TOMCAT/webapps
TOMCAT_CONFIG=$TOMCAT/conf/server.xml
TOMCAT_START=$TOMCAT/bin/startup.sh
TOMCAT_ARCHIVE=$TOMCAT.tar.gz
TOMCAT_URL=https://archive.apache.org/dist/tomcat/tomcat-7/v7.0.59/bin/$TOMCAT_ARCHIVE
TOMCAT_PORT=80

MYSQL_URL=http://cliqr-appstore.s3.amazonaws.com/petclinic/petclinic.sql
MYSQL_FILE=petclinic.sql

WAR_URL=http://cliqr-appstore.s3.amazonaws.com/petclinic/petclinic.war
WAR_FILE=petclinic.war

SERVER_XML_URL=https://raw.githubusercontent.com/Srujana77/Test/master/server.xml
SERVER_XML_FILE= server.xml
SERVER_XML_FILE_LOC=$TOMCAT/conf/

WEB_XML_URL=https://raw.githubusercontent.com/Srujana77/Test/master/web.xml
WEB_XML_FILE=web.xml
WEB_XML_FILE_LOC=$TOMCAT/webapps/petclinic/WEB-INF/

####Download Tomcat tarfile
if [ ! -e $TOMCAT ]; then
    if [ ! -r $TOMCAT_ARCHIVE ]; then
	if [ -n "$(which curl)" ]; then
	    curl -O $TOMCAT_URL
	elif [ -n "$(which wget)" ]; then
	    wget $TOMCAT_URL
	fi
    fi

    if [ ! -r $TOMCAT_ARCHIVE ]; then
	echo "Tomcat could not be downloaded." 1>&2
	echo "Verify that eiter curl or wget is installed." 1>&2
	echo "If they are, check your internet connection and try again." 1>&2
	echo "You may also download $TOMCAT_ARCHIVE and place it in this folder." 1>&2
	exit 1
    fi

    tar -zxf $TOMCAT_ARCHIVE
    rm $TOMCAT_ARCHIVE
fi

if [ ! -w $TOMCAT -o ! -w $TOMCAT_WEBAPPS ]; then
    echo "$TOMCAT and $TOMCAT_WEBAPPS must be writable." 1>&2
    exit 1
fi


####Configure tomcat to start with port 80
sed -i s/8080/$TOMCAT_PORT/g $TOMCAT_CONFIG

####Install MySql Server
echo "mysql-server-5.5 mysql-server/root_password password welcome1" | debconf-set-selections
echo "mysql-server-5.5 mysql-server/root_password_again password welcome1" | debconf-set-selections
apt-get -y install mysql-server-5.5


###Download sql file
if [ -n "$(which curl)" ]; then
	curl -O $MYSQL_URL
elif [ -n "$(which wget)" ]; then
	wget $MYSQL_URL
fi

####Load sql file
mysql -u root -pwelcome1 < $MYSQL_FILE


###Download war file
if [ -n "$(which curl)" ]; then
	curl -O $WAR_URL
elif [ -n "$(which wget)" ]; then
	wget $WAR_URL
fi

if [ ! -r $WAR_FILE ]; then
    echo "$WAR_FILE is missing. Download it and run this again to deploy it." 1>&2
else
    cp $WAR_FILE $TOMCAT_WEBAPPS
fi


#Configure mysql with tomcat
export CLASSPATH=$CLASSPATH:/usr/share/java/mysql-connector-java.jar

###Download server xml file
if [ -n "$(which curl)" ]; then
	curl -O $SERVER_XML_URL
elif [ -n "$(which wget)" ]; then
	wget $SERVER_XML_URL
fi

#Copy server xml to tomcat configuration

if [ ! -r $SERVER_XML_FILE ]; then
    echo "$WAR_FILE is missing. Download it and run this again to deploy it." 1>&2
else
    cp $SERVER_XML_FILE $SERVER_XML_FILE_LOC
fi


###Download web xml file
if [ -n "$(which curl)" ]; then
	curl -O $WEB_XML_URL
elif [ -n "$(which wget)" ]; then
	wget $WEB_XML_URL
fi

#Copy server xml to tomcat configuration

if [ ! -r $WEB_XML_FILE ]; then
    echo "$WAR_FILE is missing. Download it and run this again to deploy it." 1>&2
else
    cp $WEB_XML_FILE $WEB_XML_FILE_LOC
fi


$TOMCAT_START
