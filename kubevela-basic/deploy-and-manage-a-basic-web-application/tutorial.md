# 部署和管理一个 web 应用

## 安装 KubeVela

### 什么是 KubeVela ？

一言以蔽之，**KubeVela 是一个简单易用且高度可扩展的应用管理平台与核心引擎**。KubeVela 是基于 Kubernetes 与 OAM 技术构建的。

详细的说，对于应用开发人员来讲，KubeVela 是一个非常低心智负担的云原生应用管理平台，核心功能是让开发人员方便快捷地在 Kubernetes 上定义与交付现代微服务应用，无需了解任何 Kubernetes 本身相关的细节。在这一点上，KubeVela 可以被认为是**云原生社区的 Heroku**。

另一方面，对于平台团队来讲，KubeVela 是一个强大并且高可扩展的云原生应用平台核心引擎。基于这样一个引擎，平台团队可以快速、高效地以 Kubernetes 原生的方式在 KubeVela 中植入任何来自云原生社区的应用管理能力，从而基于 KubeVela 打造出自己需要的云原生平台，比如：云原生数据库 PaaS、云原生 AI 平台、甚至 Serverless 服务。在这一点上，KubeVela 可以被认为是**一个“以应用为中心”的 Kubernetes 发行版**，以 OAM 为核心，让平台团队可以基于 KubeVela 快速打造出属于自己的 PaaS、Serverless 乃至任何面向用户的云原生平台项目。

### 安装 Kubernetes

TBD

### 安装 KubeVela

1. 为 KubeVela 添加 helm chart repo
    ```shell
    helm repo add kubevela https://kubevelacharts.oss-accelerate.aliyuncs.com/core
    ```

2. 更新 chart repo
    ```shell
    helm repo update
    ```

3. 安装 KubeVela
    ```shell
    helm install --create-namespace -n vela-system kubevela kubevela/vela-core
    ```

4. 验证是否安装成功
    ```shell
    helm test kubevela -n vela-system
    ```

    ```shell
    Pod kubevela-application-test pending
    Pod kubevela-application-test pending
    Pod kubevela-application-test running
    Pod kubevela-application-test succeeded
    NAME: kubevela
    LAST DEPLOYED: Tue Apr 13 18:42:20 2021
    NAMESPACE: vela-system
    STATUS: deployed
    REVISION: 1
    TEST SUITE:     kubevela-application-test
    Last Started:   Fri Apr 16 20:49:10 2021
    Last Completed: Fri Apr 16 20:50:04 2021
    Phase:          Succeeded
    TEST SUITE:     first-vela-app
    Last Started:   Fri Apr 16 20:49:10 2021
    Last Completed: Fri Apr 16 20:49:10 2021
    Phase:          Succeeded
    NOTES:
    Welcome to use the KubeVela! Enjoy your shipping application journey!
    ```


## 部署应用

构建应用 `first-app` 如下 `app.yaml`：

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: first-app
spec:
  components:
    - name: helloworld
      type: webservice
      properties:
        image: oamdev/helloworld-python:v1
        env:
          - name: "TARGET"
            value: "KubeVela"
        port: 8080
```

部署应用：

```shell
$ kubectl apply -f app.yaml
```

检查应用部署情况：

```shell
$ kubectl describe application first-app
Name:         first-app
Namespace:    default
Labels:       <none>
Annotations:  API Version:  core.oam.dev/v1beta1
Kind:         Application
Metadata:
  Creation Timestamp:  2021-05-14T07:53:50Z
  Generation:          1
  Resource Version:  80396556
  Self Link:         /apis/core.oam.dev/v1beta1/namespaces/default/applications/first-app
  UID:               a3ce4891-6b2b-49c0-890e-388214755003
Spec:
  Components:
    Name:  helloworld
    Properties:
      Env:
        Name:   TARGET
        Value:  KubeVela
      Image:    oamdev/helloworld-python:v1
      Port:     8080
    Type:       webservice
Status:
  ...
  Services:
    Healthy:  true
    Name:     helloworld
    Workload Definition:
      API Version:  apps/v1
      Kind:         Deployment
  Status:           running
Events:
  Type    Reason         Age                From         Message
  ----    ------         ----               ----         -------
  Normal  Parsed         84s (x3 over 86s)  Application  Parsed successfully
  Normal  Rendered       84s (x3 over 86s)  Application  Rendered successfully
  Normal  FailedApply    84s (x3 over 85s)  Application  Applied successfully
  Normal  HealthChecked  84s (x3 over 85s)  Application  Health checked healthy
  Normal  Deployed       84s (x3 over 85s)  Application  Deployed successfully
```

应用部署成功，并且 `Deployment` `helloworld` 也生成了。

```shell
$ kubectl get deployment
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
helloworld   1/1     1            1           3m22s
```

## 给应用添加 Ingress trait

`Ingress` trait 可以给指定应用的域名、访问路径和端口，如下 `app-v1.yaml`：

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: first-app
spec:
  components:
    - name: helloworld
      type: webservice
      properties:
        image: oamdev/helloworld-python:v1
        env:
          - name: "TARGET"
            value: "KubeVela"
        port: 8080
      traits:
        - type: ingress
          properties:
            domain: abc.com 
            http:
              /: 8080
```

提交应用：

```shell
$ kubectl apply -f app-v1.yaml
application.core.oam.dev/first-app configured


$ kubectl describe application first-app
Name:         first-app
Namespace:    default
Labels:       <none>
Annotations:  API Version:  core.oam.dev/v1beta1
Kind:         Application
Metadata:
  Creation Timestamp:  2021-05-14T10:15:32Z
  Generation:          2
...
Status:
  ...
  Services:
    Healthy:  true
    Name:     helloworld
    Traits:
      Healthy:  true
      Message:  Visiting URL: abc.com, IP: 47.243.62.107
      Type:     ingress
    Workload Definition:
      API Version:  apps/v1
      Kind:         Deployment
  Status:           running
Events:
  Type    Reason             Age              From         Message
  ----    ------             ----             ----         -------
  Normal  Parsed             3s (x3 over 7s)  Application  Parsed successfully
  Normal  Rendered           3s (x3 over 5s)  Application  Rendered successfully
  Normal  FailedApply        3s (x3 over 4s)  Application  Applied successfully
  Normal  FailedHealthCheck  3s (x3 over 4s)  Application  Health checked healthy
  Normal  HealthChecked      3s (x3 over 4s)  Application  Health checked healthy
  Normal  Deployed           3s (x3 over 4s)  Application  Deployed successfully
```

在本地设置 hosts：

```shell
$ cat /etc/hosts
47.243.62.107 abc.com
```

访问应用：
```shell
$ curl abc.com
Hello KubeVela!
```

## 扩容应用

`Scaler` trait 可以手动扩容应用，比如给应用设置 4 个副本数量，如下 `app-v2.yaml`：

```yaml
apiVersion: core.oam.dev/v1beta1
kind: Application
metadata:
  name: first-app
spec:
  components:
    - name: helloworld
      type: webservice
      properties:
        image: oamdev/helloworld-python:v1
        env:
          - name: "TARGET"
            value: "KubeVela"
        port: 8080
      traits:
        - type: scaler
          properties:
            replicas: 4
```

提交应用：

```shell
$ kubectl apply -f app-v2.yaml
application.core.oam.dev/first-app configured


$ kubectl describe application first-app
Name:         first-app
Namespace:    default
Labels:       <none>
Annotations:  API Version:  core.oam.dev/v1beta1
Kind:         Application
Metadata:
  Creation Timestamp:  2021-05-14T10:15:32Z
  Generation:          3
Spec:
  Components:
    Name:  helloworld
    Properties:
      Env:
        Name:   TARGET
        Value:  KubeVela
      Image:    oamdev/helloworld-python:v1
      Port:     8080
    Traits:
      Properties:
        Replicas:  4
      Type:        scaler
    Type:          webservice
Status:
  Services:
    Healthy:  true
    Name:     helloworld
    Traits:
      Healthy:  true
      Type:     scaler
    Workload Definition:
      API Version:  apps/v1
      Kind:         Deployment
  Status:           running
Events:
  Type    Reason             Age                From         Message
  ----    ------             ----               ----         -------
  Normal  Parsed             31s (x5 over 19m)  Application  Parsed successfully
  Normal  Rendered           31s (x5 over 19m)  Application  Rendered successfully
  Normal  FailedApply        31s (x5 over 18m)  Application  Applied successfully
  Normal  FailedHealthCheck  31s (x5 over 18m)  Application  Health checked healthy
  Normal  HealthChecked      31s (x4 over 18m)  Application  Health checked healthy
  Normal  Deployed           31s (x4 over 18m)  Application  Deployed successfully
```

观察 workload Deployment，副本数量为 4：
```shell
$ kubectl get deployment
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
helloworld   4/4     4            4           2d22h
```

## 恭喜完成教程

Congratulations!