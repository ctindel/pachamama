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

# Add the elastic key and repos in case we want to install some elastic software
curl -s https://packages.elastic.co/GPG-KEY-elasticsearch | apt-key add -
echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-6.x.list

docker-compose -f /root/docker-compose.yml up -d
