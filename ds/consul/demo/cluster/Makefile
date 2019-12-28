# ####################################
# @file: Makefile
# @name: Consul Cluster Demo
# @date: 2019-12-12 16:22:21
# @tver: 20191129
# ####################################


DATA_SUF       := $(shell date +"%Y.%m.%d.%H.%M.%S")

CONSUL	:= /usr/local/bin/consul
AGENT		:= $(CONSUL) agent

MASTER_NAME := consul-01
NODE_NAME 	:= $(shell hostname -s)


# ####################################
# Dashboard AREA
# ####################################
start: start-with-conf
stop:
	kill -9 `ps -elf | grep "consul agent"  | grep -v grep  | awk '{print $$4}'`

query: query-node-by-dns query-svc-by-dns query-svc-by-api

status: status-members status-by-http


# ####################################
# Start AREA
# ####################################
start-quick:
	$(AGENT) -dev
start-with-conf:
	$(AGENT) -dev  -config-dir=$(CURDIR)/conf
start-bg:
	nohup $(AGENT) -dev -config-dir=$(CURDIR)/conf >/var/log/consul/consul.log 2>&1 &


# ####################################
# Cluster AREA
# ####################################
start-server-fg:
	$(AGENT) -server -bootstrap-expect=1  \
		-data-dir=/data/$(NODE_NAME) \
		-node=$(NODE_NAME) \
		-enable-script-checks=true -config-dir=$(CURDIR)/conf \
		-client 0.0.0.0 -ui

start-node-fg:
	$(AGENT) -data-dir=/data/$(NODE_NAME) \
		-node=$(NODE_NAME) \
		-enable-script-checks=true -config-dir=$(CURDIR)/conf \
		-ui

start-server:
	nohup $(AGENT) -server -bootstrap-expect=1  \
		-data-dir=/data/$(NODE_NAME) \
		-node=$(NODE_NAME) \
		-enable-script-checks=true -config-dir=$(CURDIR)/conf \
		-client 0.0.0.0 -ui \
		>/var/log/consul/$(NODE_NAME).log 2>&1 &

start-node:
	nohup $(AGENT) -data-dir=/data/$(NODE_NAME) \
		-node=$(NODE_NAME) \
		-enable-script-checks=true -config-dir=$(CURDIR)/conf \
		-ui \
		>/var/log/consul/$(NODE_NAME).log 2>&1 &

join-cluster:
	$(CONSUL) join $(MASTER_NAME)


# ####################################
# Feature AREA
# ####################################
query-node-by-dns:
	@echo "# 使用 DNS 接口来查询节点（默认端口：8600）"
	dig @127.0.0.1 -p 8600 local13.node.consul
	@echo

query-svc-by-dns:
	@echo "# 使用 DNS API"
	dig @127.0.0.1 -p 8600 web.service.consul
	@echo
	@echo "# 使用 DNS API 查找 SRV 记录"
	dig @127.0.0.1 -p 8600 web.service.consul SRV
	@echo

query-svc-by-api:
	@echo "# 使用 HTTP API 查询"
	curl http://localhost:8500/v1/catalog/service/web
	@echo


# ####################################
# Status AREA
# ####################################
status-members:
	@echo "# 查看集群成员"
	$(CONSUL) members
	@echo

status-by-http:
	@echo "# 使用 HTTP API 查看"
	curl localhost:8500/v1/catalog/nodes
	@echo


# ####################################
# Utils AREA
# ####################################
clean:
	rm -rvf *.bak *.log


# ####################################
# Ref AREA
# ####################################
# https://www.jianshu.com/p/7d20dc58c9fc
