#!/usr/bin/env bash

ROOTAPP=$(dirname $(realpath -s $0))
WHOAMI=$(whoami)
USERID=$(id -u $WHOAMI)
GROUPID=$(id -g $WHOAMI)

lxc-stop mesa
lxc-destroy mesa
cp -v $ROOTAPP/lxc.conf.sample $ROOTAPP/lxc.conf && \
sed -i "s@<PATHTOAPP>@$ROOTAPP@g" $ROOTAPP/lxc.conf && \
sed -i "s@<USERID>@$USERID@g" $ROOTAPP/lxc.conf && \
sed -i "s@<GROUPID>@$GROUPID@g" $ROOTAPP/lxc.conf && \
lxc-create -t download -n mesa -f $ROOTAPP/lxc.conf -- -d debian -r bullseye -a amd64 --no-validate && \
rm -fv $ROOTAPP/lxc.conf  && \
lxc-unpriv-start mesa && \
sleep 15 && \
lxc-attach mesa -- /root/build.sh && \
lxc-stop mesa
lxc-destroy mesa

#echo 'Start cleaning...'
#cd $ROOTAPP/mesa && \
#rm -rf !('build.sh'|'lxcup.sh'|'mesa'|'lxc.conf.sample') && \
#echo 'Done'

