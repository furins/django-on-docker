
# COMANDI DISPONIBILI
init: ./.env.dev ./.env.prod ./.env.prod.db ./webapp

build: ./.env.dev ./webapp
	docker-compose build

build-prod: ./.env.prod ./.env.prod.db ./webapp
	docker-compose -f docker-compose.prod.yml build

up-prod: ./.env.prod ./.env.prod.db ./webapp
	docker-compose -f docker-compose.prod.yml up -d

up-non-daemon-prod: ./.env.prod ./.env.prod.db ./webapp
	docker-compose -f docker-compose.prod.yml up

up: ./.env.dev ./webapp
	docker-compose up -d

up-non-daemon: ./.env.dev ./webapp
	docker-compose up

start: ./.env.dev ./webapp
	docker-compose start

stop: ./.env.dev ./webapp
	docker-compose stop

restart: ./.env.dev ./webapp
	docker-compose stop && docker-compose start

shell-nginx: ./.env.dev ./webapp
	docker exec -ti nz01 /bin/sh

shell-web: ./.env.dev ./webapp
	docker exec -ti dz01 /bin/sh

shell-db: ./.env.dev ./webapp
	docker exec -ti pz01 /bin/sh

log-nginx: ./.env.dev ./webapp
	docker-compose logs nginx

log-web: ./.env.dev ./webapp
	docker-compose logs web

log-db: ./.env.dev ./webapp
	docker-compose logs db

collectstatic: ./.env.dev ./webapp
	docker exec dz01 /bin/sh -c "python manage.py collectstatic --noinput"

# specifici file

./.env.dev:
	cp webapp_template/environment/.env.dev-sample ./.env.dev

./.env.prod:
	cp webapp_template/environment/.env.prod-sample ./.env.prod

./.env.prod.db:
	cp webapp_template/environment/.env.prod.db-sample ./.env.prod.db

./webapp:
	cp -R webapp_template/webapp ./webapp
	echo "aggiungere submoduli nella cartella src attraverso il comando 'git submodule add <repository_path> <submodule_name>'"
