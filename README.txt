Problem Statement: Assume that MySQL table has huge data and this cannot be processed using MySQL. You need to put this data in HDFS and then process the data using Map- Reduce. Once the data is processed, processed data need to be put back into MySQL back for reporting purpose.

Solution: I have used sqoop for import and export of data from and to MySQL and Hive for doing the processing. I have assumed, MySQL client is not installed on the local computer. 

Input Dataset: 
https://github.com/thebigjc/HackReduce/tree/master/datasets/nyse/daily_prices/NYSE_daily_prices_subset.csv


Following items are required to execute this project:
1. Login credentials for MySQL
2. Download dataset into your computer

Note, this example used hortonworks hadoop. To use this solution using cloudera, replace '/apps/hive/warehouse/...' with /user/cloudera/warehouse/..' in the export command.
