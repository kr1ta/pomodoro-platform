#!/bin/bash
set -e

sleep 15

kafka-topics --create --topic stat --partitions 3 --replication-factor 1 --if-not-exists --bootstrap-server kafka:9092
kafka-topics --create --topic user-created --partitions 3 --replication-factor 1 --if-not-exists --bootstrap-server kafka:9092

echo "topics are created"