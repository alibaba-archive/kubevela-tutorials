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
            domain: localhost 
            http:
              /: 8080
```

