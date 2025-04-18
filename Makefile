.PHONY: hammer
hammer:
	hey -z 10s http://localhost:8080


.PHONY: up
up:
	docker compose up --build
