#!/bin/bash
#set -e
#set -x
cd "$(dirname "$0")"

f="./.env"
if [[ -f "$f" ]]; then
  echo "Loaded $f" >&2
  . "$f"
fi

#export PUSHOVER_TOKEN 
#export PUSHOVER_DEVICE 

get_tickers(){
	if [[ $1 == "tradeogre" ]];then
		curl --silent --output tradeogre-tickers.txt https://tradeogre.com/api/v1/markets
	elif [[ $1 == okex ]];then
		curl --silent --output okex-spot-tickers.txt https://www.okex.com/api/v5/market/tickers?instType=SPOT
	elif [[ $1 == mexc ]];then
		curl --silent --output mexc-tickers.txt https://www.mexc.com/open/api/v2/market/ticker
	fi	
}

get_price_usdt() {
tickers=("$@")
loop_index=0
for i in "${tickers[@]}"
do
	((loop_index++))
	if [[ $i == "TRTL" ]];then
		#echo "Find out how to calculate TRTL_LTC from tradeogre, then convert LTC to USDT with okex"
		ticker="TRTL_USDT"
		#mexc_data=$(cat mexc-tickers.txt | jq --arg ticker $ticker '.data[] | select(.symbol|startswith("'$ticker'"))')
		mexc_data=$(cat mexc-tickers.txt | jq --arg ticker $ticker '.data[] | select(.symbol|startswith("'$ticker'"))')
		#Parse response	
		last=$(echo $mexc_data | jq -r '.last')
		high24=$(echo $mexc_data | jq -r '.high')
		low24=$(echo $mexc_data | jq -r '.low')
		volume24=$(echo $mexc_data | jq -r '.volume')
		bid=$(echo $mexc_data | jq -r '.bid')
		ask=$(echo $mexc_data | jq -r '.ask')
		ticker_data=$(jq -c -n --arg ask $ask --arg bid $bid --arg last $last --arg high24 $high24 --arg low24 $low24 --arg volume24 $volume24 '{instId: "TRTL-USDT", askPx: $ask, bidPx: $bid, last: $last, high24h: $high24, low24h: $low24, vol24h: $volume24}')
	else
	#echo $i
	ticker="$i-USDT"
	ticker_data=$(cat okex-spot-tickers.txt | jq --arg ticker $ticker '.data[] | select(.instId|startswith("'$ticker'"))')
	#echo $ticker_data | jq .instId
	#print_price $ticker_data
	fi

	#Parse ticker data	
	#echo $ticker_data | jq
	ticker=$(echo $ticker_data | jq -r '.instId')
	ask=$(echo $ticker_data | jq -r '.askPx')
	bid=$(echo $ticker_data | jq -r '.bidPx')
	last=$(echo $ticker_data | jq -r '.last')
	high24=$(echo $ticker_data | jq -r '.high24h')
	low24=$(echo $ticker_data | jq -r '.low24h')
	volume24=$(echo $ticker_data | jq -r '.vol24h')
	message="Ask: $ask | Bid: $bid | Last: $last | High 24h: $high24 | Low 24h: $low24 | Vol 24h: $volume24" 

	#Save to csv price-log.csv
	now_date=$(date "+%Y-%m-%d %H:%M:%S")
	if [[ ! -f price-log.csv ]];then
		touch price-log.csv
	fi
	if [[ -z $(cat price-log.csv | grep "ticker") ]];then
	echo "date,ticker,ask,bid,last,high24h,low24h,volume24h" >> price-log.csv
	fi
	echo "$now_date,$ticker,$ask,$bid,$last,$high24,$low24,$volume24" >> price-log.csv 
	echo "[$now_date] $ticker | $message"

	#Send to pushover every hour
	if (( $(expr $date_epoch - $stats_date_epoch) >= 3600 ));then
		po_response=$(pushover -t ${PUSHOVER_TOKEN} -u ${PUSHOVER_DEVICE} -m "${message}" -p -1 -T "${ticker}" -v -s alien)
		if (( loop_index == "${#tickers[@]}" ));then
			stats_date_epoch=$(date +"%s")
		fi
	fi
done
}
stats_date_epoch=0
while true;do
date_epoch=$(date +"%s")
get_tickers mexc
get_tickers okex
#get_tickers tradeogre
tokens=( SOL XCH FTM SLP XLM )
get_price_usdt "${tokens[@]}"
sleep 900
done
