# Key

---
## admin login
|Key|Value|Memo|
|:--|--|--|
|user|admin||
|password||`cat data/admin.password`|


---
## Quick Started

#### vim /etc/hostname
```bash
127.0.0.1 nexus.xxx.com
```

#### ~/.m2/settings.xml
```xml
  <servers>
    <server>
      <username>deploy_username</username>
      <password>deploy_password</password>
      <id>nexus-xxx-releases</id>
    </server>
    <server>
      <username>deploy_username</username>
      <password>deploy_password</password>
      <id>nexus-xxx-snapshots</id>
    </server>
  </servers>

  <mirrors>
    <!-- 本地仓库 -->
    <mirror>
      <id>nexus-xxx-proxy-aliyun</id>
      <mirrorOf>central</mirrorOf>
      <name>nexus-xxx-proxy-aliyun</name>
      <url>http://nexus.xxx.com:8081/repository/nexus-proxy-aliyun/</url>
    </mirror>

    <mirror>
      <id>nexus-xxx-proxy-central</id>
      <mirrorOf>central</mirrorOf>
      <name>nexus-xxx-proxy-central</name>
      <url>http://nexus.xxx.com:8081/repository/maven-central/</url>
    </mirror>

    <mirror>
      <id>nexus-xxx-releases</id>
      <mirrorOf>central</mirrorOf>
      <name>nexus-xxx-releases</name>
      <url>http://nexus.xxx.com:8081/repository/maven-releases/</url>
    </mirror>

    <mirror>
      <id>nexus-xxx-snapshots</id>
      <mirrorOf>central</mirrorOf>
      <name>nexus-xxx-snapshots</name>
      <url>http://nexus.xxx.com:8081/repository/maven-snapshots/</url>
    </mirror>

  </mirrors>

```

#### 项目 pom.xml
```xml
  <distributionManagement>
    <repository>
      <id>nexus-xxx-releases</id>
      <url>
        http://nexus.xxx.com:8081/repository/maven-releases/
      </url>
    </repository>
    <snapshotRepository>
      <id>nexus-xxx-snapshots</id>
      <url>
        http://nexus.xxx.com:8081/repository/maven-snapshots/
      </url>
    </snapshotRepository>
  </distributionManagement>
```

---
## 参考
- https://github.com/sonatype/docker-nexus
