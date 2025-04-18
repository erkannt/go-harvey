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
- `make hammer | less`
- in separate terminal: `make release` to recreate container every 0.5s

`hey` reports errors due to port not listening and peer resetting connection.

### With caddy

- `make up COMPOSE=docker-compose.caddy.yaml`
- `make hammer`
- in separate terminal: `make release COMPOSE=docker-compose.caddy.yaml` to recreate container every 0.5s

`hey` reports 502s from caddy

