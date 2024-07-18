up:
	docker compose -f test/docker-compose.yml up -d --build

down:
	docker compose -f test/docker-compose.yml down

build:
	docker build -t teamspeak:fishi0x01 -f alpine/Dockerfile alpine

