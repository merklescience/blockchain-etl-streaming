#!/usr/bin/env bash

gcloud deployment-manager deployments create ethereum-etl-pubsub-1 --template deployment_manager_pubsub_ethereum.py
