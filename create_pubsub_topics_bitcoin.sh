#!/usr/bin/env bash


cur_time=date
echo $cur_time
gcloud deployment-manager deployments create bitcoin-etl-pubsub-bsv-2 --template deployment_manager_pubsub_bitcoin.py




