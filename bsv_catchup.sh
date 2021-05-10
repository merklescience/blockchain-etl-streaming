# How to jump ahead to the latest block
update_block_number=$1
# latest_block_api_url=$2
# delete the workflow
helm del --purge bchsv-0-lag;
helm del --purge bchsv;
# copy last synced block to respective gcs bucket
# copy last_synced_block number to local
if [ $update_block_number == 'latest' ]
then
	block_number=$(curl --user "rpcbitc":"uen23JHdei89KL90BSIMsei23Tfssd8+we432" -k http://34.70.144.157:8332/ --data-binary '{"jsonrpc": "1.0", "id":"curltest", "method": "getblockchaininfo", "params": [] }' -H 'content-type: text/plain;'|jq ".result.blocks")
	echo $((block_number+1)) > /Users/saurabhdaga/repos/stream/blockchain-etl-streaming/values/bitcoin/bitcoin_cash_sv/last_synced_block.txt
	gsutil cp /Users/saurabhdaga/repos/stream/blockchain-etl-streaming/values/bitcoin/bitcoin_cash_sv/last_synced_block.txt gs://blockchain-etl-streaming/bitcoin_cash_sv-etl/streaming/last_synced_block.txt
	gsutil cp /Users/saurabhdaga/repos/stream/blockchain-etl-streaming/values/bitcoin/bitcoin_cash_sv/last_synced_block.txt gs://blockchain-etl-streaming/bitcoin_cash_sv-etl/streaming-0-lag/last_synced_block.txt
else
	gsutil cp gs://blockchain-etl-streaming/bitcoin_cash_sv-etl/streaming/last_synced_block.txt /Users/saurabhdaga/repos/stream/blockchain-etl-streaming/values/bitcoin/bitcoin_cash_sv/last_synced_block.txt
	# update last_synced_block_number
	block_number=$(cat /Users/saurabhdaga/repos/stream/blockchain-etl-streaming/values/bitcoin/bitcoin_cash_sv/last_synced_block.txt)
	echo $((block_number+1)) > /Users/saurabhdaga/repos/stream/blockchain-etl-streaming/values/bitcoin/bitcoin_cash_sv/last_synced_block.txt
	gsutil cp /Users/saurabhdaga/repos/stream/blockchain-etl-streaming/values/bitcoin/bitcoin_cash_sv/last_synced_block.txt gs://blockchain-etl-streaming/bitcoin_cash_sv-etl/streaming/last_synced_block.txt
	gsutil cp /Users/saurabhdaga/repos/stream/blockchain-etl-streaming/values/bitcoin/bitcoin_cash_sv/last_synced_block.txt gs://blockchain-etl-streaming/bitcoin_cash_sv-etl/streaming-0-lag/last_synced_block.txt
fi
# deploy cluster to kubernetes
helm install --name bchsv-0-lag --namespace btc charts/blockchain-etl-streaming --values values/bitcoin/bitcoin_cash_sv/values-0-lag.yaml
helm install --name bchsv --namespace btc charts/blockchain-etl-streaming --values values/bitcoin/bitcoin_cash_sv/values.yaml