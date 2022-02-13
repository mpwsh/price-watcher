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

