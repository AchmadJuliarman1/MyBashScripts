#!/bin/bash

user="devops"

for host in $(cat remhosts)
do 
    echo "============================"
    echo "Connecting to $host"
    echo "============================"
    scp setup.sh $user@$host:/tmp/
    
    echo "============================"
    echo "Executing scripts on $host"
    echo "============================"
    ssh $user@$host sudo /tmp/setup.sh
    ssh $user@$host sudo rm -rf /tmp/setup.sh
done