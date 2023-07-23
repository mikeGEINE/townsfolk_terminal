SHELL=/bin/sh

UID:=$(SHELL id -u)
GID:=$(SHELL id -g)

export UID GID

app-setup: app-build app-db-prepare

app-build:
	docker-compose build

app-up:
	docker-compose up

app-ash:
	docker-compose run --rm app ash

app-console:
	docker-compose run --rm app bundle exec rails c

app-yarn:
	docker-compose run --rm app yarn install

app-bundle:
	docker-compose run --rm app bundle install


app-db-psql:
	docker-compose run --rm app psql -d townsfolk_terminal_development -U postgres -W -h db

app-db-prepare: app-db-drop app-db-create app-db-migrate app-db-seed

app-db-create:
	docker-compose run --rm app rails db:create RAILS_ENV=development

app-db-migrate:
	docker-compose run --rm app rails db:migrate

app-db-rollback:
	docker-compose run --rm app rails db:rollback

app-db-seed:
	docker-compose run --rm app rails db:seed

app-db-reset:
	docker-compose run --rm app rails db:reset

app-db-drop:
	docker-compose run --rm app rails db:drop


TEST_PATH := $(or $(TEST_PATH),spec/)
test:
	docker-compose run -e DATABASE_URL=postgresql://postgres@db/townsfolk_terminal_test -e RAILS_ENV=test -e SPEC_DISABLE_FACTORY_LINT=$(SPEC_DISABLE_FACTORY_LINT) -e SPEC_DISABLE_WEBPACK_COMPILE=$(SPEC_DISABLE_WEBPACK_COMPILE) --rm app rspec -f d $(TEST_PATH)

test-prepare:
	docker-compose run -e DATABASE_URL=postgresql://postgres@db/townsfolk_terminal_test -e RAILS_ENV=test --rm app ash -c "bundle install; rails db:test:prepare"

test-db-drop:
	docker-compose run -e DATABASE_URL=postgresql://postgres@db/townsfolk_terminal_test -e RAILS_ENV=test --rm app rails db:drop

test-rails-system:
	docker-compose run -e DATABASE_URL=postgresql://postgres@db/townsfolk_terminal_test -e RAILS_ENV=test --rm app bin/rails test:system

.PHONY: app-up test
