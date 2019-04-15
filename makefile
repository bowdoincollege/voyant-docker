#
# Voyant Tools
#

# Basic container setup
VM_NAME=$(shell /usr/bin/awk '/container_name: / {print $$2;}' docker-compose.yaml)
DATA_VOLUME=${VM_NAME}_data
TIMESTAMP=$(shell date +"%Y%m%dT%H%M%S")

# For container backups
LAST_BACKUP=$(shell ls -t ${VM_NAME}-*.gz | head -n1)
BACKUP_FILE=${VM_NAME}-${TIMESTAMP}.gz
BACKUP_CMD=tar Cczf / - ./data

# Show the container and its volumes
default:
	docker-compose ps

# Back up the container's data by exporting and compressing it
# backup:
# 	docker exec ${VM_NAME} ${BACKUP_CMD} > ${BACKUP_FILE}

# Make a new container by restoring an existing database
# restore: distclean
# 	docker-compose up --no-start
# 	docker run -i --rm -v ${DATA_VOLUME}:/data --name helper -w / busybox tar xzvf - < ${LAST_BACKUP}
# 	docker-compose up -d

test:
	docker run -it --rm ${VM_NAME} /bin/sh

# Build the container's image
build:
	docker-compose build --compress --force-rm --pull

# Make (and start) the container
run: container

container:
	$(aws ecr get-login --no-include-email --region us-east-1)
	docker-compose up 

# Start an already existing container that has been stopped
start:
	docker-compose start

# Attach to a running contiainer with sh
attach:
	docker exec -it ${VM_NAME} /bin/sh

# Attach to a running container's console
console:
	tmux attach-session -t ${VM_NAME} \
	|| tmux new-session -s ${VM_NAME} docker attach ${VM_NAME}

# Stop a running container
stop:
	docker-compose stop

# Update a container's image; stop, pull new image, and restart
update: clean
	-docker-compose pull ${DOCKER_IMAGE}
	make container 

# Delete container's volume (DANGER)
clean-volume:
	docker-compose down -v

# Delete a container (WARNNING)
clean: stop
	docker-compose down

# Delete a container and it's volumes (DANGER)
distclean: clean clean-volume
