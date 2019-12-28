# ####################################
# Name: base-docker-compose-apps
# FileVersion: 20191227
# ####################################

.PHONY: all clean


DATA_SUF = $(shell date +"%Y.%m.%d.%H.%M.%S")
GUP_MSG = "Auto Commited at $(DATA_SUF)"

ifdef MSG
	GUP_MSG = "$(MSG)"
endif


# ####################################
# Dashboard AREA
# ####################################
up:
down: clean


# ####################################
# Git AREA
# ####################################
include ./git.mk


# ####################################
# Utils AREA
# ####################################
clean:
	rm -rvf *.bak *.log
