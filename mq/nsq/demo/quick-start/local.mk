# ####################################
# Local test AREA
# ####################################


LOCAL_NSQ_BIN_DIR	:= /usr/local/nsq/bin
export PATH:=${PATH}:${LOCAL_NSQ_BIN_DIR}

TOPIC := nsq-study-20191218
TOPIC_OPT := topic=$(TOPIC)

# ####################################
# Local AREA
# ####################################
local-nsq-env:
	@echo ${PATH}
local-nsq-nsqlookupd:
	nsqlookupd

local-nsq-status:
	watch -n 0.5 "curl -s http://127.0.0.1:4151/stats"

# nodes
local-nsq-nsqd: local-nsq-nsqd-n1
local-nsq-nsqd-n1:
	nsqd --lookupd-tcp-address=127.0.0.1:4160 --data-path=../../data/node1
local-nsq-nsqd-n2:
	nsqd --lookupd-tcp-address=127.0.0.1:4160 --tcp-address ":4152" --http-address ":4153" --data-path=../../data/node2
local-nsq-nsqd-n3:
	nsqd --lookupd-tcp-address=127.0.0.1:4160 --tcp-address ":4154" --http-address ":4155" --data-path=../../data/node3

# web-ui
local-nsq-web:
	nsqadmin --lookupd-http-address=127.0.0.1:4161

# consumer
local-nsq-topic-sub-01:
	nsq_to_file --$(TOPIC_OPT) --output-dir=../../data/sub-01 --lookupd-http-address=127.0.0.1:4161
local-nsq-topic-sub-02:
	nsq_to_file --$(TOPIC_OPT) --output-dir=../../data/sub-02 --lookupd-http-address=127.0.0.1:4161
local-nsq-topic-sub-03:
	nsq_to_file --$(TOPIC_OPT) --output-dir=../../data/sub-03 --lookupd-http-address=127.0.0.1:4161

# producer
# publish an initial message (creates the topic in the cluster, too):
local-nsq-topic-create:
	curl -d 'hello world 1' 'http://127.0.0.1:4151/pub?$(TOPIC_OPT)'
local-nsq-topic-pub-a:
	for x in `seq 10000`; do \
		curl -d "hello world $$x - `date +"%Y-%m-%d-%H-%M-%S"`" 'http://127.0.0.1:4151/pub?$(TOPIC_OPT)'; \
		sleep 0; \
	done;


local-nsq-clean:
	find ../../data -name "*.log" -exec rm {} \;
