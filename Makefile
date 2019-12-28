# ####################################
# Name: MySQL 集群环境
# FileVersion: 20191113
# ####################################


DK	:= docker
DC	:= docker-compose


# ####################################
# 环境变量 AREA
# ####################################
ENV_FILE := ./.env
MASTER_PASSWD := $(shell sed '/MASTER_PASSWD/!d;s/.*=//' $(ENV_FILE))
SLAVE_PASSWD := $(shell sed '/SLAVE_PASSWD/!d;s/.*=//' $(ENV_FILE))
REPL_PASSWD := $(shell sed '/REPL_PASSWD/!d;s/.*=//' $(ENV_FILE))
REPL_NAME := $(shell sed '/REPL_NAME/!d;s/.*=//' $(ENV_FILE))


# ####################################
# Config AREA
# ####################################
SVC_HOST := $(shell hostname -a)
SERVER_GROUPS := g1 g2
SLAVE_NAMES := s2 s3


# ####################################
# Dashboard AREA
# ####################################
status: status-port
start: ginit start-servers
stop: stop-servers
test: test-core
ginit: init-dir

bash:
	docker exec -it mysql-g1-s1 bash


# ####################################
# Status/Info AREA
# ####################################
status-port:
	sudo netstat -lntop | grep docker | sort -n -k4
	docker ps -a | grep mysql


# ####################################
# Init AREA
# 	init-dir: 
# ####################################
init-dir:
	# 创建数据目录
	for x in $(shell sed -n "/# DATA-DIR-BEGIN/,/# DATA-DIR-END/p" .gitignore | grep -v "#"); do \
		echo "verify dir $$x"; \
		[ -d "$$x" ] || mkdir -p "$$x"; \
	done;
	# 给集群配置文件加上读权限，否则会因用户id不同，导致配置读取不生效
	find conf -name "*.cnf" -exec chmod +r {} \;
	# log目录可写
	chmod o+w ../../../log/mysql


# ####################################
#　Server Group AREA
# ####################################
start-servers:
	for x in $(SERVER_GROUPS); do docker-compose -f mysql-$$x.yml up -d; done;
stop-servers:
	for x in $(SERVER_GROUPS); do docker-compose -f mysql-$$x.yml down; done;


# ####################################
# Debug AREA
# ####################################
start-g1-fg:
	docker-compose -f mysql-g1.yml up
start-g1:
	docker-compose -f mysql-g1.yml up -d
stop-g1:
	docker-compose -f mysql-g1.yml down


# ####################################
# Test AREA
# ####################################
test-core:


# ####################################
# Cluster AREA
# ####################################
post-init-cluster: cluster-add-repl-account
cluster-add-repl-account:
	# 为主节点添加备份用户
	for x in $(SERVER_GROUPS); do \
		$(DK) exec -it mysql-$${x}-s1 mysql -uroot -p${MASTER_PASSWD} \
			-e "CREATE USER '${REPL_NAME}'@'%' IDENTIFIED BY '${REPL_PASSWD}' REQUIRE SSL;" \
			-e "GRANT REPLICATION SLAVE ON *.* TO '${REPL_NAME}'@'%';" \
			-e "flush privileges;" ; \
	done;

cluster-start-slave:
	# 从库使用主库的备份账号连接主库，并开始备份mysql-$${x}-s1
	for x in $(SERVER_GROUPS); do \
		for y in $(SLAVE_NAMES); do \
			$(DK) exec -it mysql-$${x}-$${y} mysql -uroot -p${SLAVE_PASSWD} \
				-e "CHANGE MASTER TO MASTER_HOST='mysql-$${x}-s1', MASTER_PORT=3306, MASTER_USER='${REPL_NAME}', MASTER_PASSWORD='${REPL_PASSWD}', MASTER_AUTO_POSITION=1, MASTER_SSL=1;" \
				-e "START SLAVE;" ; \
		done; \
	done;

cluster-status-master:
	for x in $(SERVER_GROUPS); do \
		$(DK) exec -it mysql-$${x}-s1 mysql -uroot -p${MASTER_PASSWD} -e "show variables like '%gtid%';"; \
	done;

cluster-status-slave:
	for x in $(SERVER_GROUPS); do \
		for y in $(SLAVE_NAMES); do \
			$(DK) exec -it mysql-$${x}-$${y} mysql -uroot -p${SLAVE_PASSWD} -e "SHOW SLAVE STATUS\G"; \
		done; \
	done;

cluster-stop-slave:
	for x in $(SERVER_GROUPS); do \
		for y in $(SLAVE_NAMES); do \
			$(DK) exec -it mysql-$${x}-$${y} mysql -uroot -p${SLAVE_PASSWD} -e "STOP SLAVE"; \
		done; \
	done;

cluster-reset-slave:
	for x in $(SERVER_GROUPS); do \
		for y in $(SLAVE_NAMES); do \
			$(DK) exec -it mysql-$${x}-$${y} mysql -uroot -p${SLAVE_PASSWD} -e "RESET SLAVE"; \
		done; \
	done;


# ####################################
# Utils AREA
# ####################################
clean:
	rm -rvf *.bak *.log
	$(DK) ps -a | grep Exited | awk '{print $$1}' | xargs $(DK) rm
