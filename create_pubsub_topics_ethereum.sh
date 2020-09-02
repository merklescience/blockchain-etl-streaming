#!/usr/bin/env bash

gcloud deployment-manager deployments create ethereum-etl-pubsub-2 --template deployment_manager_pubsub_ethereum.py
