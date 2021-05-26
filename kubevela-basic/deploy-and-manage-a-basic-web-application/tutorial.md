# 部署和管理一个 web 应用

## 安装 KubeVela

### 确认 Kubernetes 已安装

你打开实验后，后台会默认会你装好 Kubernetes 集群，请通过一下命令检查 Kubernetes 集群已可用。

```bash
$ kubectl version
```

### 安装 KubeVela

1. 为 KubeVela 添加 helm chart repo
    ```bash
    helm repo add kubevela https://kubevelacharts.oss-accelerate.aliyuncs.com/core
    ```

2. 更新 chart repo
    ```bash
    helm repo update
    ```

3. 安装 KubeVela
    ```bash
    helm install --create-namespace -n vela-system kubevela kubevela/vela-core
    ```

4. 验证是否安装成功
    ```bash
    helm test kubevela -n vela-system
    ```

    ```bash
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

```bash
$ kubectl apply -f app.yaml
```

检查应用部署情况：

```bash
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

```bash
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

```bash
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

```bash
$ cat /etc/hosts
47.243.62.107 abc.com
```

访问应用：
```bash
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

```bash
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
```bash
$ kubectl get deployment
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
helloworld   4/4     4            4           2d22h
```

## 恭喜完成教程

Congratulations!