# app name. A github repository will be created with this name
app_name = myapp
template_repo = django_dockerized
github_user = furins

# COMANDI DISPONIBILI
init: ./.env.dev ./.env.prod ./.env.prod.db ./webapp

./webapp:
	gh repo create $(app_name) --private --clone --template https://github.com/$(github_user)/$(template_repo)
	mv $(app_name) webapp
	@echo please wait 5 seconds until the newly created repository propagates on github ...
	@sleep 5s
	git submodule add https://github.com/$(github_user)/$(app_name) webapp

clean: check_clean
	# RUN CLEAN BEFORE COMMITTING TO THE ORIGIN REPOSITORY
	rm -rf ./webapp
	# see https://stackoverflow.com/questions/20929336/git-submodule-add-a-git-directory-is-found-locally-issue
	rm -rf .git/modules/webapp
	rm ./.env.dev
	rm ./.env.prod
	rm ./.env.prod.db
	rm ./.gitmodules

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

check_clean:
	@echo "Are you sure? [y/N] " && read ans && [ $${ans:-N} = y ]