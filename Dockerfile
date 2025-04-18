FROM golang:alpine AS builder

WORKDIR /app
RUN apk --no-cache add gcc musl-dev

# compile dependencies in a separate layer to improve caching
COPY go.mod go.sum ./
RUN go mod download
COPY .docker/dependencies.go .
RUN CGO_ENABLED=1 GOOS=linux go build dependencies.go
RUN rm dependencies dependencies.go

COPY main.go .
RUN CGO_ENABLED=1 GOOS=linux go build -o harvey .

FROM alpine AS prod
RUN apk add curl
COPY --from=builder /app/harvey /harvey

ENTRYPOINT ["/harvey"]
HEALTHCHECK --interval=1s --timeout=1s --start-period=5s --start-interval=0.5s --retries=3 CMD [ "curl", "http://localhost:8080" ]
