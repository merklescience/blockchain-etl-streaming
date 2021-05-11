
# How to jump ahead to the latest block
update_block_number=$1
latest_block_api_url=$2
local_filename = values/bitcoin/bitcoin_cash_sv/last_synced_block.txt 
gcs_filename = gs://blockchain-etl-streaming/bitcoin_cash_sv-etl/streaming/last_synced_block.txt 
gcs_0_lag_filename = gs://blockchain-etl-streaming/bitcoin_cash_sv-etl/streaming-0-lag/last_synced_block.txt 

# delete the workflow
helm del --purge bchsv-0-lag;
helm del --purge bchsv; 

# copy last synced block to respective gcs bucket
# copy last_synced_block number to local
if [ $update_block_number == 'latest' ]
then
	block_number=$(curl --user "rpcbitc":"uen23JHdei89KL90BSIMsei23Tfssd8+we432" -k $latest_block_api_url --data-binary '{"jsonrpc": "1.0", "id":"curltest", "method": "getblockchaininfo", "params": [] }' -H 'content-type: text/plain;'|jq ".result.blocks")
	echo $((block_number+1)) > $local_filename

	gsutil cp $local_filename $gcs_filename
	gsutil cp $local_filename $gcs_0_lag_filename
else
	gsutil cp $gcs_filename $local_filename

	# update last_synced_block_number
	block_number=$(cat $local_filename)
	echo $((block_number+1)) > $local_filename

	gsutil cp $local_filename $gcs_filename
	gsutil cp $local_filename $gcs_0_lag_filename
fi

# deploy cluster to kubernetes
helm install --name bchsv-0-lag --namespace btc charts/blockchain-etl-streaming --values values/bitcoin/bitcoin_cash_sv/values-0-lag.yaml
helm install --name bchsv --namespace btc charts/blockchain-etl-streaming --values values/bitcoin/bitcoin_cash_sv/values.yaml