#!/usr/bin/env bash

gcloud deployment-manager deployments create ripple-etl-pubsub-1 --template deployment_manager_pubsub_ripple.py
