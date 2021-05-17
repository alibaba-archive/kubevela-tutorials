# 什么是 KubeVela ？

一言以蔽之，**KubeVela 是一个简单易用且高度可扩展的应用管理平台与核心引擎**。KubeVela 是基于 Kubernetes 与 OAM 技术构建的。

详细的说，对于应用开发人员来讲，KubeVela 是一个非常低心智负担的云原生应用管理平台，核心功能是让开发人员方便快捷地在 Kubernetes 上定义与交付现代微服务应用，无需了解任何 Kubernetes 本身相关的细节。在这一点上，KubeVela 可以被认为是**云原生社区的 Heroku**。

另一方面，对于平台团队来讲，KubeVela 是一个强大并且高可扩展的云原生应用平台核心引擎。基于这样一个引擎，平台团队可以快速、高效地以 Kubernetes 原生的方式在 KubeVela 中植入任何来自云原生社区的应用管理能力，从而基于 KubeVela 打造出自己需要的云原生平台，比如：云原生数据库 PaaS、云原生 AI 平台、甚至 Serverless 服务。在这一点上，KubeVela 可以被认为是**一个“以应用为中心”的 Kubernetes 发行版**，以 OAM 为核心，让平台团队可以基于 KubeVela 快速打造出属于自己的 PaaS、Serverless 乃至任何面向用户的云原生平台项目。

# 安装 Kubernetes

TBD

# 安装 KubeVela

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
