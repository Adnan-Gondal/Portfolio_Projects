# Automated Crypto Web Scraper

**Author**: Adnan Aslam  
**Language**: Python  

## Project Overview
This Python script is an automated web scraper that collects real-time price data for Bitcoin from [CoinMarketCap](https://coinmarketcap.com/). The data, including the cryptocurrency name, current price, and timestamp, is saved into a CSV file for future analysis.

## Features
- **Real-Time Scraping**: Retrieves the current price of Bitcoin every 20 seconds.
- **CSV Storage**: Appends each data entry (name, price, timestamp) to a CSV file for easy access and record-keeping.
- **Data Processing**: Formats price data by removing currency symbols for seamless numerical analysis.

## Requirements
- **Python 3.x**
- **Libraries**:
  - `requests` for HTTP requests
  - `BeautifulSoup` from `bs4` for HTML parsing
  - `pandas` for data handling and CSV storage
  - `datetime`, `os`, and `time` for timestamping and scheduling

To install dependencies, run:
```bash
pip install requests beautifulsoup4 pandas


## Usage
1. Insert your desired file path in the file_path variable in the crypto_web_scrapper function.
2. Run the script : python crypto_scraper.py
3. The script will scrape Bitcoin's current price every 20 seconds and append the results to crypto_scrapper.csv.

## Note
Frequent scraping may lead to IP blocking by the website. Consider adding a longer delay or using a less frequent schedule for sustained data collection.
