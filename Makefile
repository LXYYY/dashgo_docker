.PHONY: build run run-root

XAUTH:=/tmp/.docker.xauth
DOCKER_NAME:=dashgo

build:
	docker build --build-arg myuser=${shell whoami} -t $(DOCKER_NAME) .

#not work now
run-root: build
	make build
	#touch $(XAUTH)
	#xauth nlist ${DISPLAY} | sed -e 's/^..../ffff/' | xauth -f $(XAUTH) nmerge -
	docker run -it --name $(DOCKER_NAME)  --rm \
	   --privileged \
	   --env="DISPLAY=$DISPLAY" \
	   --env="QT_X11_NO_MITSHM=1" \
	   --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
	   -e XAUTHORITY=$(XAUTH) \
	   --volume="$(XAUTH):$(XAUTH)" \
	   -e HOME=${HOME} \
	   -v "${HOME}/Workspace:${HOME}/Workspace/" \
	   -v /etc/group:/etc/group:ro \
	   -v /etc/localtime:/etc/localtime \
	   -v /etc/passwd:/etc/passwd:ro \
	   --security-opt seccomp=unconfined \
	   --net=host \
	   --privileged \
	   $(DOCKER_NAME)

run:
	make build
	#touch $(XAUTH)
	#xauth nlist ${DISPLAY} | sed -e 's/^..../ffff/' | xauth -f $(XAUTH) nmerge -
	docker run -it --name $(DOCKER_NAME)  --rm \
	   --privileged \
	   --env="DISPLAY=$DISPLAY" \
	   --env="QT_X11_NO_MITSHM=1" \
	   --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
	   -e XAUTHORITY=$(XAUTH) \
	   --volume="$(XAUTH):$(XAUTH)" \
	   -e HOME=${HOME} \
	   -v "${HOME}/Workspace:${HOME}/Workspace/" \
	   -u $(shell id -u ${USER} ):$(shell id -g ${USER}) \
	   -v /etc/group:/etc/group:ro \
	   -v /etc/localtime:/etc/localtime \
	   -v /etc/passwd:/etc/passwd:ro \
	   --security-opt seccomp=unconfined \
	   --net=host \
	   --privileged \
	   $(DOCKER_NAME)

attach:
	docker exec -it $(DOCKER_NAME) /bin/bash
