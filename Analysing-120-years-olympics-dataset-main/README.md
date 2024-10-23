# Analysing-120-years-olympics-dataset
## <a href="https://modeanalytics.com/gondal/reports/f0d4d38d9ed4" target="_blank">Mode Analytics SQL Queries(Click Here)</a>
## Introduction
I have conducted an in-depth analysis using a comprehensive dataset covering the last 120 years of Olympic history. This dataset, obtained from this [link](https://www.dropbox.com/sh/0wqw8fmiwrzr8ef/AABQijjQM522INXX1FCdamzma?dl=0), encompasses a wide range of information related to participants, events, winners, and more. While this dataset has the potential to benefit individuals from various fields and interests, my focus has been to extract intriguing trivia and valuable insights into the evolving trends of Olympic victories.

Additionally, I have examined the historical trends in female participation over the years. This crucial aspect of the dataset allows us to explore how the involvement of female athletes in the Olympics has changed and evolved throughout history. Through this analysis, I aim to provide a holistic understanding of these trends by utilizing the rich data at hand.

## Target Audience
My data analysis project is tailored to engage sports and history enthusiasts, particularly those who enjoy revisiting the rich tapestry of Olympic history. If you're someone who appreciates delving into the past, exploring the data related to height, weight, medals won, and more in Olympic sports events held every 4 years from 1896 to 2016, this analysis is designed for you.

Furthermore, I believe that this exploration can hold value not only for fellow enthusiasts but also for analysts and professionals in the sports industry. Coaches, strategists, and athletes can potentially glean insights from these historical findings to fine-tune their approaches for current and future Olympic competitions. By delving into the lessons of the past, we can strive for even greater excellence in the world of sports.

## Initial Data Exploration
The data was originally presented in two CSV files: one containing information regarding participating countries and regions, and the other comprising details about events, winners, athletes, and more. To facilitate the analysis, I downloaded these files and subsequently uploaded them onto the Mode Analytics Platform. Within the platform, I harnessed the power of SQL queries to transform and organize the data to meet the specific requirements of the analysis.

In our dataset, we work with two primary tables: "athlete_events" and "noc_regions".

#### Athlete_events
This table holds detailed information about individual participation in Olympic events. It contains a wealth of data related to athletes, events, and their performances. The crucial linking factor here is the "Noc" code, which serves as the primary key. It connects and associates each athlete and event with the respective country they represent.

#### Noc_region 
In contrast, the "noc_regions" table focuses on region codes and names. These region codes are linked to the "Noc" in the "athlete_events" table, establishing a relationship between the two tables. It's important to note that this relationship is one-to-many, meaning that one region can encompass multiple teams and participants. However, at the individual athlete or team level, there can't be more than one associated region.

This data structure allows us to connect countries or teams (through the "Noc" code) with their respective regions, providing valuable context and facilitating analysis based on regional information.

## Findings
1) The more the number of participation of atheletes from a particular country, the higher the probability of winninag a medal of that
country. United States has the highest number of participation and has won most number of gold medals.
2) Over the period of time, the number of participation of female atheletes has increased tremendously.
3) The participation of female atheletes in Summer Olympics is higher as compared to Winter Olympics games.
4) Maximum number of males winning medals are from height ranges between 170 – 200 cms and from weight ranges between 80 – 120 kgs.
5) Maximum number of female winning medals are from height ranges between 150 – 170 cms and from weight ranges between 50 – 75 kgs.

## Potential Further Analysis Opportunities
#### Participant Count and Medal Distribution by Sport
Analyzing the number of participants in different sports and examining how medals are distributed across these sports. This can shed light on the popularity and competitiveness of various Olympic events.

#### Medal Distribution by Age
Investigating the distribution of medals based on athletes' age groups. Understanding how age influences success in different sports can provide valuable insights into the relationship between experience, youth talent, and Olympic achievements.

These analyses can offer a more comprehensive view of Olympic data and uncover patterns that may not be immediately apparent.
