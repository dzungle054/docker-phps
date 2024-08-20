# ------------------------------------------------------------
# For development
# ------------------------------------------------------------
up:
	docker compose up -d
up-build:
	docker compose up -d --build
build:
	docker compose build --no-cache --force-rm
stop:
	docker compose stop
down:
	docker compose down --remove-orphans
restart:
	@make down
	@make up
logs:
	docker compose logs
ps:
	docker compose ps
nginx:
	docker container exec -it nginx_docker ash
npm-i:
	docker container exec -it php_docker npm install
npm-dev:
	docker container exec -it php_docker npm run dev
npm-build:
	docker container exec -it php_docker npm run build
npm-build-watch:
	docker container exec -it php_docker npm run watch
npm-fix:
	docker container exec -it php_docker npm run fix
composer-i:
	docker container exec php_docker composer install
composer-fix:
	docker container exec -it php_docker composer fixer
ide-helper:
	docker container exec -it php_docker bash -c "php artisan ide-helper:models -N && php artisan ide-helper:generate"
artisan-%:
	docker container exec -it php_docker php artisan ${@:artisan-%=%}
seed-%:
	docker container exec -it php_docker bash -c "php artisan db:seed --class=${@:seed-%=%}"

# ------------------------------------------------------------
# Common
# ------------------------------------------------------------
php:
	docker container exec -it php_docker bash