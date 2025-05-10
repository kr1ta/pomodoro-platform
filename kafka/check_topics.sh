#!/bin/sh
set -e

KAFKA_BOOTSTRAP=kafka:9092
TOPICS="stat user-created"

echo "Waiting for Kafka to be available..."
while ! echo "stats" | nc kafka 9092 > /dev/null 2>&1; do
  sleep 5
done

for topic in $TOPICS; do
  echo "Checking if topic '$topic' exists..."
  while true; do
    result=$(kafka-topics --bootstrap-server $KAFKA_BOOTSTRAP --list 2>/dev/null)
    if echo "$result" | grep -q "$topic"; then
      echo "Topic '$topic' is ready."
      break
    else
      echo "Topic '$topic' not found. Creating it..."
      kafka-topics --create --topic "$topic" --partitions 1 --replication-factor 1 --if-not-exists --bootstrap-server $KAFKA_BOOTSTRAP
    fi
    sleep 5
  done
done

echo "All topics are ready!"