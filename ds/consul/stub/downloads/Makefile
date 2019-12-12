# ####################################
# Dashboard AREA
# ####################################
# 官方提供的zip，这里太坑了，
# 我们把zip转成tar，减少Dockerfile操作

BASENAME := $(shell ls consul_*.zip | head -1 | sed "s:.zip::g")

conv:
	unzip $(BASENAME).zip \
		&& chmod +x consul \
		&& tar -jcvf $(BASENAME).tar.bz2 consul \
		&& rm consul

haha:
	echo ${BASENAME}

clean:
	-rm consul
	-rm $(BASENAME).tar.bz2
