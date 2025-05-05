COMPOSE ?= docker-compose.yaml

.PHONY: hammer
hammer:
	hey -z 10s http://localhost:8080

.PHONY: status
status:
	@curl http://localhost:8080/status

.PHONY: stop
stop:
	docker compose -f $(COMPOSE) down

.PHONY: up
up:
	docker network create caddy || true
	docker compose -f $(COMPOSE) up --build --wait --remove-orphans

.PHONY: release
release:
	while true; do docker compose -f $(COMPOSE) up --force-recreate -d harvey; sleep 2; done

.PHONY: rolling-release
rolling-release:
	while true; do \
		docker compose -f $(COMPOSE) up --force-recreate --wait harvey; \
		docker compose -f $(COMPOSE) up --force-recreate --wait harvey-replica; \
	done

.PHONY: logs
logs:
	docker compose -f $(COMPOSE) logs -f
