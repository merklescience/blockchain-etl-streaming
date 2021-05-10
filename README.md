# Blockchain ETL Streaming

Streams the following Ethereum entities to Pub/Sub using 
[ethereum-etl stream](https://github.com/blockchain-etl/ethereum-etl#stream):

- blocks
- transactions
- logs
- token_transfers 
- traces
- contracts
- tokens

Streams blocks and transactions to Pub/Sub using 
[bitcoin-etl stream](https://github.com/blockchain-etl/bitcoin-etl#stream). Supported chains:

- bitcoin
- bitcoin_cash
- dogecoin
- litecoin
- dash
- zcash

## Deployment Instructions

1. Create a cluster:

```bash
gcloud container clusters create ethereum-etl-streaming \
--zone us-central1-a \
--num-nodes 1 \
--disk-size 10GB \
--machine-type custom-2-4096 \
--network default \
--subnetwork default \
--scopes pubsub,storage-rw,logging-write,monitoring-write,service-management,service-control,trace
```


```bash
gcloud container clusters create blockchain-etl-streaming \
--zone us-central1-a \
--num-nodes 1 \
--disk-size 10GB \
--machine-type custom-2-4096 \
--network default \
--subnetwork default \
--scopes pubsub,storage-rw,logging-write,monitoring-write,service-management,service-control,trace
```


2. Get `kubectl` credentials:

```bash
gcloud container clusters get-credentials ethereum-etl-streaming \
--zone us-central1-a
```

```bash
gcloud container clusters get-credentials blockchain-etl-streaming \
--zone us-central1-a
```

3. Create Pub/Sub topics (use `create_pubsub_topics_ethereum.sh`)
  - "crypto_ethereum.blocks" 
  - "crypto_ethereum.transactions" 
  - "crypto_ethereum.token_transfers" 
  - "crypto_ethereum.logs" 
  - "crypto_ethereum.traces" 
  - "crypto_ethereum.contracts" 
  - "crypto_ethereum.tokens" 

Put the prefix to `ethereum_base/configMap.yaml`, `PUB_SUB_TOPIC_PREFIX` property.

4. Create GCS bucket. Upload a text file with block number you want to start streaming from to 
`gs:/<YOUR_BUCKET_HERE>/ethereum-etl/streaming/last_synced_block.txt`.
Put your GCS path to `overlays/ethereum/block_data/configMap.yaml`, `GCS_PREFIX` property, 
e.g. `gs:/<YOUR_BUCKET_HERE>/ethereum-etl/streaming`.

5. Update `ethereum_base/configMap.yaml`, `PROVIDER_URI` property to point to your Ethereum node.

5. Create "ethereum-etl-app" service account with roles:
    - Pub/Sub Editor
    - Storage Object Admin

Download the key. Create a Kubernetes secret:

6. Install [helm] (https://github.com/helm/helm#install) 

```bash
brew install helm
helm init  
bash patch-tiller.sh
```

```bash
kubectl create secret generic streaming-app-key --namespace eth --from-file=key.json=$HOME/Desktop/merkle/staging-btc-etl-4a48dd2254f2.json 


```


```bash
kubectl create secret generic streaming-app-key --namespace btc --from-file=key.json=$HOME/Desktop/merkle/staging-btc-etl-4a48dd2254f2.json 

```


7. Copy [example values](example_values) directory to `values` dir and adjust all the files at least with your bucket and project ID.
8. Install ETL apps via helm using chart from this repo and values we adjust on previous step, for example:
```bash

 helm del --purge bch-0-lag; 
 helm del --purge btc-0-lag; 
 helm del --purge litecoin-0-lag;
helm del --purge bchsv-0-lag; 
 helm del --purge eth-blocks-cointaint-0-lag;
 helm del --purge eth-traces-cointaint-0-lag;

 helm del --purge ripple; 
 helm del --purge btc; 
 helm del --purge litecoin;
 helm del --purge bch; 
 helm del --purge bchsv; 
helm del --purge eth-blocks
helm del --purge eth-traces
helm del --purge eth-blocks-0-lag
helm del --purge eth-traces-0-lag

helm install --name bchsv-0-lag --namespace btc charts/blockchain-etl-streaming --values values/bitcoin/bitcoin_cash_sv/values-0-lag.yaml



helm install --name bchsv --namespace btc charts/blockchain-etl-streaming --values values/bitcoin/bitcoin_cash_sv/values.yaml


helm install --name litecoin-0-lag --namespace btc charts/blockchain-etl-streaming --values values/bitcoin/litecoin/values-0-lag.yaml
helm install --name bch-0-lag --namespace btc charts/blockchain-etl-streaming --values values/bitcoin/bitcoin_cash/values-0-lag.yaml
helm install --name btc-0-lag --namespace btc charts/blockchain-etl-streaming --values values/bitcoin/bitcoin/values-0-lag.yaml


helm install --name btc --namespace btc charts/blockchain-etl-streaming --values values/bitcoin/bitcoin/values.yaml
helm install --name bch --namespace btc charts/blockchain-etl-streaming --values values/bitcoin/bitcoin_cash/values.yaml
helm install --name litecoin --namespace btc charts/blockchain-etl-streaming --values values/bitcoin/litecoin/values.yaml

helm install --name eth-blocks --namespace eth charts/blockchain-etl-streaming --values values/ethereum/values.yaml --values values/ethereum/block_data/values.yaml
helm install --name eth-traces --namespace eth charts/blockchain-etl-streaming --values values/ethereum/values.yaml --values values/ethereum/trace_data/values.yaml 

helm install --name eth-blocks-0-lag --namespace eth charts/blockchain-etl-streaming --values values/ethereum/values-0-lag.yaml --values values/ethereum/block_data/values-0-lag.yaml
helm install --name eth-traces-0-lag --namespace eth charts/blockchain-etl-streaming --values values/ethereum/values-0-lag.yaml --values values/ethereum/trace_data/values-0-lag.yaml 


helm install --name ripple --namespace ripple charts/blockchain-etl-streaming --values values/ripple/values.yaml  



gsutil cp /Users/saurabhdaga/repos/stream/blockchain-etl-streaming/values/ripple/last_synced_block.txt gs://blockchain-etl-streaming/bitcoin_cash_sv-etl/streaming/last_synced_block.txt 


helm install --name eos-blocks --namespace eos charts/blockchain-etl-streaming --values values/eos/block_data/values.yaml
``` 
Ethereum block and trace data streaming are decoupled for higher reliability. 

9. Use `describe` command to troubleshoot, f.e. :

```bash
kubectl describe pods -n btc
kubectl describe node [NODE_NAME]
```

Refer to [blockchain-etl-dataflow](https://github.com/blockchain-etl/blockchain-etl-dataflow)
for connecting Pub/Sub to BigQuery.



Parameters


How to jump ahead to the latest block
delete the workflow
helm del --purge bchsv-0-lag;
helm del --purge bchsv; 

gsutil cp gs://blockchain-etl-streaming/bitcoin_cash_sv-etl/streaming/last_synced_block.txt .
gsutil cp  gs://blockchain-etl-streaming/bitcoin_cash_sv-etl/streaming-0-lag/last_synced_block.txt . 

gsutil cp /Users/saurabhdaga/repos/stream/blockchain-etl-streaming/values/bitcoin/bitcoin_cash_sv/last_synced_block.txt gs://blockchain-etl-streaming/bitcoin_cash_sv-etl/streaming/last_synced_block.txt 
gsutil cp /Users/saurabhdaga/repos/stream/blockchain-etl-streaming/values/bitcoin/bitcoin_cash_sv/last_synced_block.txt gs://blockchain-etl-streaming/bitcoin_cash_sv-etl/streaming-0-lag/last_synced_block.txt 

helm install --name bchsv-0-lag --namespace btc charts/blockchain-etl-streaming --values values/bitcoin/bitcoin_cash_sv/values-0-lag.yaml
helm install --name bchsv --namespace btc charts/blockchain-etl-streaming --values values/bitcoin/bitcoin_cash_sv/values.yaml

