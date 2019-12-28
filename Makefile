# ####################################
# Name: os-c7
# FileVersion: 20191127
# ####################################


DK	:= docker
DC	:= docker-compose
DK_EXEC := docker exec -it -u foobar
SELF_DO := make --no-print-directory -C .

DATA_SUF = $(shell date +"%Y.%m.%d.%H.%M.%S")

include ./.env

PROJ_NAME := $(shell basename $(CURDIR))

CMD := bash


# ####################################
# Dashboard AREA
# ####################################
start: init-dir
	$(DC) up -d
stop:
	$(DC) down
config:
	$(DC) config

bash: sh
sh: sh1
sh1:
	$(DK_EXEC) kong-01 $(CMD)
sh2:
	$(DK_EXEC) kong-02 $(CMD)
sh3:
	$(DK_EXEC) kong-03 $(CMD)

rebuild-then-start: stop init-dir
	$(DK) images | grep -q $(OS_IMG_TAG) && $(DK) rmi $(OS_IMG_TAG) || true
	$(DC) up --build -d


# ####################################
# Web Dashboard AREA
# ####################################
web:
	[ -d build ] || mkdir build 
	git clone git@github.com:PGBI/kong-dashboard.git build/kong-dashboard
	git clone https://github.com/pantsel/konga.git build/konga


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
	chmod o+w ../../../../log/$(PROJ_NAME)
	[ -L log ] || ln -s ../../../../log/$(PROJ_NAME) log


download:
	for x in `cat stub/downloads/url.lst | grep -v "^#"`; do \
		wget -P stub/downloads $$x; \
	done;


# ####################################
# Utils AREA
# ####################################
rm-img:
	make --no-print-directory -C . stop
	docker rmi $(CONSUL_IMG_TAG)
clean:
	rm -rvf log/* *.bak
