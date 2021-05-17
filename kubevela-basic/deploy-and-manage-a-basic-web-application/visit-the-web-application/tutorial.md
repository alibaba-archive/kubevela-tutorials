# 给应用添加 Ingress trait

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
