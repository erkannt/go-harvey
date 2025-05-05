# go harvey

Explore containerised web apps that use SQLite for persistance.

## Inspiration

- [litestream question](https://github.com/benbjohnson/litestream/issues/624)
- [Harvey the WAL-Banger](https://tangentsoft.com/sqlite/doc/trunk/walbanger/README.md)
- [Consider sqlite](https://blog.wesleyac.com/posts/consider-sqlite)

## Other interesting documents

- [Scaling sqlite to 4M QPS](https://use.expensify.com/blog/scaling-sqlite-to-4m-qps-on-a-single-server)
- [Appropriate Uses For SQLite](https://sqlite.org/whentouse.html)
- [ How To Corrupt An SQLite Database File](https://sqlite.org/howtocorrupt.html)

## How to use

### Naive happy case

- `make up` to start single container
- `make hammer` to hit container with requests using [hey](https://github.com/rakyll/hey) for 10s

`hey` reports 70k req/s with no errors.

### Dropped traffic during release

- `make up`
- in separate terminal: `make release` to recreate container every 2s
- `make hammer | less`

`hey` reports errors due to port not listening and peer resetting connection.

### With caddy

- `make up COMPOSE=docker-compose.caddy-proxy.yaml`
- in separate terminal: `make release COMPOSE=docker-compose.caddy-proxy.yaml`
- `make hammer`

`hey` reports 10% 502s from caddy

### With retries

By setting `lb_retries` to a high number we can avoid having requests fail. However response duration suffers from our frequent restarts.
Sleeping for 2s between restarts lets us achieve 9k req/s with under 1% of responses taking over 1s.

- `make up COMPOSE=docker-compose.caddy-retry.yaml`
- in separate terminal: `make release COMPOSE=docker-compose.caddy-retry.yaml`
- `make hammer`

### Manual rolling release

`docker compose up` has no mechanism to recreate containers sequentially so we have to do this manually.

Continuous but sequential container recreations result in higher req/s (ca. 17k) but we still have 0.1% or requests taking 1s.

- `make up COMPOSE=docker-compose.replicas.yaml`
- `make hammer`
- in separate terminal: `make rolling-release COMPOSE=docker-compose.replicas.yaml`

### Disaster recovery

Using litestream for disaster recovery.

- `make up COMPOSE=docker-compose.litestream.yaml`
- `make hammer`
- `make status`
