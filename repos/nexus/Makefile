# ####################################
# Name: nexus
# FileVersion: 20191127
# ####################################


DK	:= docker
DC	:= docker-compose
DK_EXEC := docker exec -it

DATA_SUF = $(shell date +"%Y.%m.%d.%H.%M.%S")

include ./.env

PROJ_NAME := $(shell basename $(CURDIR))


# ####################################
# Dashboard AREA
# ####################################
start: init-dir
	$(DC) up -d
stop:
	$(DC) down
config:
	$(DC) config

sh:
	$(DK_EXEC) $(PROJ_NAME) sh
bash: sh

rebuild-then-start: stop init-dir
	$(DK) images | grep -q $(OS_IMG_TAG) && $(DK) rmi $(OS_IMG_TAG) || true
	$(DC) up --build -d

rebuild_pre:
	sudo mv data ../$(PROJ_NAME)-data
rebuild_post:
	sudo mv ../$(PROJ_NAME)-data data

test:
	curl http://localhost:8081/nexus/service/local/status

backup:
	[ -L /mnt/repo-hub -o -d /mnt/repo-hub ] && sudo rsync -avP data/ /mnt/repo-hub/$(PROJ_NAME)/ || true


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
	[ ! -d conf ]  || find conf -name "*.cnf" -exec chmod +r {} \;
	# log目录可写
	chmod o+w ../../../../log/$(PROJ_NAME)
	# data目录移交权限
	sudo chown -R 200:200 data


# ####################################
# Utils AREA
# ####################################
clean:
	rm -rvf log/* *.bak
