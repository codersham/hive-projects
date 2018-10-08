Problem Statement: Assume that MySQL table has huge data and this cannot be processed using MySQL. 
We will need to put this data in HDFS and then process the data using Map- Reduce. 
Once the data is processed, processed data need to be put into MySQL back for reporting purpose.
We will use Sqoop for import and export of data from and to MySQL and hadoop mapreduce for doing the processing.
Assume, you don't have MySQL client installed on your computer. 
Input Dataset: 
https://github.com/thebigjc/HackReduce/tree/master/datasets/nyse


Following items are required to execute this project:
1. Login credentials for MySQL
2. Download dataset into your computer

Note, this example used hortonworks hadoop to use this solution using cloudera, replace '/apps/hive/warehouse/...' with /user/cloudera/warehouse/..' in the export command.