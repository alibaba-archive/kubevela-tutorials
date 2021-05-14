# 部署应用

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

```shell script
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