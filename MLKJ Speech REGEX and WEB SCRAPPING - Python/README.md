# Martin Luther King Jr. Speech Analysis

**Author**: Adnan Aslam  
**Language**: Python  

## Project Overview
This project automates the process of web scraping, cleaning, and analyzing the words used in Martin Luther King Jr.'s speech, sourced from [AnalyticTech](http://www.analytictech.com/mb021/mlk.htm). The script scrapes the speech content, removes punctuation, converts the text to lowercase, filters out words with fewer than four letters, and finally counts the occurrences of each word. Results are saved in a CSV file for further analysis or visualization.

## Features
- **Web Scraping**: Retrieves the full text of the speech from the provided webpage.
- **Data Cleaning**: Removes unnecessary punctuation, converts to lowercase, and excludes short words for meaningful analysis.
- **Word Frequency Analysis**: Counts the frequency of each filtered word and saves the results in a CSV file.

## Requirements
- **Python 3.x**
- **Libraries**:
  - `requests` for HTTP requests
  - `BeautifulSoup` from `bs4` for HTML parsing
  - `pandas` for data handling and CSV storage
  - `re` for regex-based cleaning

Install dependencies by running:
```bash
pip install requests beautifulsoup4 pandas
