# 扩容应用

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
