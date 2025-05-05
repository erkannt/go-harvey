#!/bin/bash
set -e

if [ -f /data/state.db ]; then
	echo "Database already exists, skipping restore"
else
	echo "No database found, restoring from replica if exists"
	litestream restore -if-replica-exists /data/state.db
fi

exec litestream replicate
