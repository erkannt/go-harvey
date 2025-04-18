FROM golang:1.24 AS builder

WORKDIR /app
COPY . .
RUN CGO_ENABLED=0 go build -o harvey .

FROM scratch AS prod
COPY --from=builder /app/harvey /harvey

EXPOSE 8080
ENTRYPOINT ["/harvey"]
