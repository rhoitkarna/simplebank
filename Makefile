POSTGRES_CONTAINER=postgres
POSTGRES_USER=admin
POSTGRES_PASSWORD=changeme
POSTGRES_DB=simple_bank

postgres:
	docker run --name $(POSTGRES_CONTAINER) \
		-p 5432:5432 \
		-e POSTGRES_USER=$(POSTGRES_USER) \
		-e POSTGRES_PASSWORD=$(POSTGRES_PASSWORD) \
		-e POSTGRES_DB=$(POSTGRES_DB) \
		-d postgres:16-alpine

createdb:
	docker exec -it $(POSTGRES_CONTAINER) \
		createdb -U $(POSTGRES_USER) -O $(POSTGRES_USER) $(POSTGRES_DB)

dbshell:
	docker exec -it $(POSTGRES_CONTAINER) \
		psql -U $(POSTGRES_USER) -d $(POSTGRES_DB)

dropdb:
	docker exec -it $(POSTGRES_CONTAINER) \
		dropdb -U $(POSTGRES_USER) $(POSTGRES_DB)

migrateup:
	migrate -path db/migration \
		-database "postgresql://$(POSTGRES_USER):$(POSTGRES_PASSWORD)@localhost:5432/$(POSTGRES_DB)?sslmode=disable" \
		-verbose up

migratedown:
	migrate -path db/migration \
		-database "postgresql://$(POSTGRES_USER):$(POSTGRES_PASSWORD)@localhost:5432/$(POSTGRES_DB)?sslmode=disable" \
		-verbose down

sqlc:
	sqlc generate

.PHONY: postgres createdb dropdb dbshell migrateup migratedown sqlc