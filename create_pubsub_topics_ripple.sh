#!/usr/bin/env bash

gcloud deployment-manager deployments create ripple-etl-pubsub-4 --template deployment_manager_pubsub_ripple.py
