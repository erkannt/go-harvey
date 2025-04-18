COMPOSE ?= docker-compose.yaml

.PHONY: hammer
hammer:
	hey -z 10s http://localhost:8080


.PHONY: up
up:
	docker network create caddy || true
	docker compose -f $(COMPOSE) up --build --wait

.PHONY: release
release:
	while true; do docker compose -f $(COMPOSE) up --force-recreate -d harvey; sleep 0.5; done
