FROM golang:1.24 AS builder

WORKDIR /app
COPY go.mod main.go ./
RUN CGO_ENABLED=0 go build -o harvey .

FROM alpine AS prod
RUN apk add curl
COPY --from=builder /app/harvey /harvey

EXPOSE 8080
ENTRYPOINT ["/harvey"]
HEALTHCHECK --interval=1s --timeout=1s --start-period=5s --start-interval=0.5s --retries=3 CMD [ "curl", "http://localhost:8080" ]
