# Replace word within < > with actual information, before execution

# Create the following table in mysql db
sqoop eval \
--connect jdbc:mysql://<ip address of mysql>/<mysql_db_name> \
--username <mysql_login_id> \
-P \
--query "CREATE TABLE nasdaq_daily_prices ( \
exchange VARCHAR(35), \
stock_symbol VARCHAR(35), \
date VARCHAR(35), \
stock_price_open DOUBLE, \
stock_price_high DOUBLE, \
stock_price_low DOUBLE, \
stock_price_close DOUBLE, \
stock_volume BIGINT, \
stock_price_adj_close DOUBLE \
)"

# verify source table is created successfully
sqoop eval \
--connect jdbc:mysql://<ip address of mysql>/<mysql_db_name> \
--username <mysql_login_id> \
-P \
--query "describe nasdaq_daily_prices"

# Import nyse data to the sourec table
sqoop eval \
--connect jdbc:mysql://<ip address of mysql>/<mysql_db_name> \
--username <mysql_login_id> \
-P \
--query "LOAD DATA LOCAL INFILE '<file_location>/NYSE_daily_prices_subset.csv' \
INTO TABLE nasdaq_daily_prices \
FIELDS TERMINATED by ','"

# verify data successfully loaded into source table
sqoop eval \
--connect jdbc:mysql://<ip address of mysql>/<mysql_db_name> \
--username <mysql_login_id> \
-P \
--query "select * from nasdaq_daily_prices  limit 10"

#Create the output table in mysql
sqoop eval \
--connect jdbc:mysql://<ip address of mysql>/<mysql_db_name> \
--username <mysql_login_id> \
-P \
--query "CREATE TABLE stock_volume ( \
stock_symbol VARCHAR(35), \
total_stock_volume BIGINT \
)"

# verify output table is created successfully
sqoop eval \
--connect jdbc:mysql://<ip address of mysql>/<mysql_db_name> \
--username <mysql_login_id> \
-P \
--query "describe stock_volume"

# sqoop import: Import mysql data from source table to hive
sqoop import \
--connect jdbc:mysql://<ip address of mysql>/<mysql_db_name> \
--username <mysql_login_id> \
-P \
--table nasdaq_daily_prices \
--hive-database <hive_db_name> \
--hive-import \
--fields-terminated-by ',' \
--m 1

# Create the result table in hive
hive -e "create table <hive_db_name>.stock_volume as
select stock_symbol,sum(stock_volume) total_stock_volume from <hive_db_name>.nasdaq_daily_prices group by stock_symbol;"

# Verify the result table in hive
hive -e "select * from <hive_db_name>.stock_volume limit 10;"

# sqoop export data from HDFS to mysql output table
sqoop export \
--connect jdbc:mysql://<ip address of mysql>/<mysql_db_name> \
--username <mysql_login_id> \
-P \
--table stock_volume \
--export-dir /apps/hive/warehouse/<hive_db_name.db>/stock_volume \
--input-fields-terminated-by '\001'

# validate data is sucessfully exported in mysql
sqoop eval \
--connect jdbc:mysql://<ip address of mysql>/<mysql_db_name> \
--username <mysql_login_id> \
-P \
--query "select * from stock_volume limit 10"
