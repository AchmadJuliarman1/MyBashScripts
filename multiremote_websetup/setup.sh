#!/bin/bash

URL="https://www.tooplate.com/zip-templates/2147_titan_folio.zip"
ARTIFACT_NAME="2147_titan_folio"
TEMPDIR="/tmp/webporto"

#check error code
yum --help &> /dev/null

if [ $? -ne 0 ] 
then
    echo "Running on ubuntu"
    PACKAGE="apache2 wget unzip"
    SERVICE="apache2"
    echo "============================="
    echo "Installing package"
    echo "============================="
    sudo apt update
    sudo apt install $PACKAGE -y > /dev/null
    echo

    echo "============================="
    echo "start & enable HTTPD service"
    echo "============================="
    sudo systemctl start $SERVICE
    sudo systemctl enable $SERVICE
    echo

    echo "============================"
    echo "Working with artifact"
    echo "============================"
    sudo mkdir -p $TEMPDIR
    cd $TEMPDIR
    wget $URL
    unzip $ARTIFACT_NAME.zip > /dev/null
    sudo cp -r $ARTIFACT_NAME/* /var/www/html/
    cd /
    sudo rm -rf $TEMPDIR
    sudo systemctl restart $SERVICE
else
    echo "Running on centos"
    PACKAGE="httpd wget unzip"
    SERVICE="httpd"
    echo "============================="
    echo "Installing package"
    echo "============================="
    sudo yum install $PACKAGE -y > /dev/null
    echo

    echo "============================="
    echo "start & enable HTTPD service"
    echo "============================="
    sudo systemctl start $SERVICE
    sudo systemctl enable $SERVICE
    echo

    echo "============================"
    echo "Working with artifact"
    echo "============================"
    sudo mkdir -p $TEMPDIR
    cd $TEMPDIR
    wget $URL
    unzip $ARTIFACT_NAME.zip > /dev/null
    sudo cp -r $ARTIFACT_NAME/* /var/www/html/
    cd /
    sudo rm -rf $TEMPDIR
    sudo systemctl restart $SERVICE
fi


