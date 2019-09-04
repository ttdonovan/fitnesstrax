#!/bin/bash

export HOST="localhost"
export PORT=7000
export WEBAPP_PATH="../client/dist"
export AUTHDB="./auth.db"
export AUTHDB_SECRET="abcdefg"
export SERIES_PATH="db.series"
#cargo watch -x run -- --bin app
cargo watch -x "run --bin fitnesstrax-server"
