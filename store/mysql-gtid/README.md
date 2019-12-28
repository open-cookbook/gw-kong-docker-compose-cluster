## MySQL 集群


#### 端口分布
|组名|主|从|备注|
|:--|--|--|--|
|**g1**|**3316**|3317-3318|mysql-g1.yml|
|**g2**|**3326**|3327-3328|mysql-g2.yml|
|**g3**|**3336**|3337-3338||
|**g4**|**3346**|3347-3348||

#### Quick Started

```bash
# 以当前目录执行为例
# 如果中心化，项目根目录下执行，则为 make -C apx/22-cluster/mysql ...

# 启动
make ginit start

# 主节点，添加replicas用户
make cluster-add-repl-account

# 开启同步、查看状态、关闭同步
make cluster-start-slave
make cluster-status-slave
make cluster-stop-slave

# 同步异常复位
make cluster-reset-slave

# 主节点状态(功能再进一步完善)
make cluster-status-master

```


---
## 参考
- https://github.com/docker-library/mysql/blob/master/5.7/Dockerfile
- https://github.com/docker-library/mysql/blob/master/5.7/docker-entrypoint.sh
- https://github.com/hellxz/mysql-cluster-docker
