#!/usr/bin/env bash

timestamp() {
  date +"%T" # current time
}

echo timestamp
gcloud deployment-manager deployments create bitcoin-etl-pubsub-timestamp --template deployment_manager_pubsub_bitcoin.py
