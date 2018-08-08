#!/bin/bash

# It seems like some background task will kick off an update before we start so let's wait for that to finish before we do our install
# https://askubuntu.com/questions/132059/how-to-make-a-package-manager-wait-if-another-instance-of-apt-is-running
i=0
tput sc
while fuser /var/lib/dpkg/lock >/dev/null 2>&1 ; do
    case $(($i % 4)) in
        0 ) j="-" ;;
        1 ) j="\\" ;;
        2 ) j="|" ;;
        3 ) j="/" ;;
    esac
    tput rc
    echo -en "\r[$j] Waiting for other software managers to finish..."
    sleep 0.5
    ((i=i+1))
done


apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.0 multiverse" > /etc/apt/sources.list.d/mongodb-org-4.0.list
apt-get update
apt-get install -y mongodb-org
sed -i.bak 's/bindIp.*/bindIpAll: true/g' /etc/mongod.conf
sed -i.bak 's/#replication.*/replication:\n  replSetName: pachamama/g' /etc/mongod.conf
systemctl enable mongod
systemctl start mongod

# We need to wait until mongod is up and running on the other nodes
if [ "$HOSTNAME" = mongodb1 ]; then
    echo "We are on mongodb1, going to do the rs.initiate()"
    echo "Waiting for mongodb port 27017 to be ready on hosts mongodb2 and mongodb3"
    while ! ncat mongodb2 27017 --send-only </dev/null; do
        sleep 5
    done
    while ! ncat mongodb3 27017 --send-only </dev/null; do
        sleep 5
    done
    echo "All 3 hosts are online, initiating replica set"
    echo -e 'rs.initiate({_id: "pachamama",members:[{_id:0,host:"mongodb1"}, {_id:1,host:"mongodb2"},{_id:2,host:"mongodb3"}]})' | mongo
else
    echo "We are on $HOSTNAME, the other host mongodb1 will initiate the replica set"
fi
