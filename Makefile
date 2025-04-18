.PHONY: hammer
hammer:
	hey -z 10s http://localhost:8080


.PHONY: up
up:
	docker compose up --build --wait

.PHONY: release
release:
	while true; do docker compose up --force-recreate -d; sleep 0.5; done
