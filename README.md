## Dependencies
 - [pushover-bash](https://github.com/akusei/pushover-bash)
 - jq `apt install jq -y`
 - curl `apt install curl -y`

## Usage
Create a file called `.env` with the following values

```bash
PUSHOVER_TOKEN=<your-token>
PUSHOVER_DEVICE=<your-device>
```

Open the script `price-watcher.sh` on your prefered text editor and jump to the bottom of the file, where you'll find a variable called `tokens`.  Set the tickers of the tokens you wish to follow inside that array, save and exit.

Start the script
```bash
./price-watcher.sh
```

The script will also save the output as a CSV in a file called `price-log.csv` for future analysis.


### Output
```bash
➜ ./price-watcher.sh
Loaded ./.env
[2022-02-13 18:22:28] SOL-USDT | Ask: 93.186 | Bid: 93.185 | Last: 93.194 | High 24h: 97.367 | Low 24h: 91.361 | Vol 24h: 773699.094654
[2022-02-13 18:22:29] XCH-USDT | Ask: 79.63 | Bid: 79.57 | Last: 79.61 | High 24h: 81.22 | Low 24h: 79.05 | Vol 24h: 17390.539956
[2022-02-13 18:22:31] FTM-USDT | Ask: 1.9096 | Bid: 1.9092 | Last: 1.9094 | High 24h: 1.9886 | Low 24h: 1.885 | Vol 24h: 26245646.494426
[2022-02-13 18:22:32] SLP-USDT | Ask: 0.02928 | Bid: 0.02925 | Last: 0.02934 | High 24h: 0.03472 | Low 24h: 0.02651 | Vol 24h: 3342454636.007462
[2022-02-13 18:22:33] XLM-USDT | Ask: 0.21254 | Bid: 0.21249 | Last: 0.21246 | High 24h: 0.22192 | Low 24h: 0.21092 | Vol 24h: 46889946.994818
```
