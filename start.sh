#!/bin/bash

mkdir -p tmp/pids
rm tmp/pids/server.pid
bundle exec rails server -b 0.0.0.0
