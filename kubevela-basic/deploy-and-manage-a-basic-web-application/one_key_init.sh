#!/bin/bash

add_master(){
    sudo docker run -d --name k0s --hostname k0s --privileged --net=bridge -v /var/lib/k0s -p 6443:6443 registry.cn-shanghai.aliyuncs.com/k0s_on_handson/k0s >/dev/null 2>&1

    sleep 5

    local masterip=$(sudo docker exec k0s hostname -i)

    mkdir -p ~/.kube

    sudo docker exec k0s cat /var/lib/k0s/pki/admin.conf > ~/.kube/config

    sed -i "s/localhost/$masterip/g" ~/.kube/config

    sleep 1
}

add_worker(){

    local token=$(sudo docker exec -t -i k0s k0s token create --role=worker)

    sudo docker run -d --name k0s-worker1 --hostname k0s-worker1 --privileged --net=bridge -v /var/lib/k0s registry.cn-shanghai.aliyuncs.com/k0s_on_handson/k0s k0s worker $token >/dev/null 2>&1

    sleep 1
}

after_start(){
    local exptime=200
    local time=0
    local str=""
    local noderet=""

    while true
    do
        noderet=$(kubectl get nodes 2>&1)

        if [[ time -gt exptime ]];
        then
            echo "[k8s 环境启动失败，请刷新页面后重试]"
            break
        elif [[ $noderet == '' ]] || [[ $noderet =~ "No resources found" ]] || [[ $noderet =~ "NotReady" ]]; 
        then
            printf "[等待 k8s 环境启动 %s]\r" "$str"
            sleep 1
            ((time++))
            str+="#"
        else
            echo "[k8s 环境启动完成，共用时 $time 秒]"
            kubectl get nodes
            break
        fi
        
    done
}


echo "[开始启动 k8s 环境, 预计需要2min的时间]"

add_master

#add_worker

after_start