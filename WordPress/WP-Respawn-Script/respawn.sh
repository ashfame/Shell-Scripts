#!/bin/bash

echo '======================================'
echo '==== WordPress Respawn Script'
echo '==== @author Ashfame'
echo '==== @url https://github.com/ashfame'
echo '==== @url https://twitter.com/ashfame'
echo '======================================'


# Pass first argument as path to wp-config.php
WPCONFIGPATH="$1"

if [ $# -eq 0 ]
then
	echo "Assuming wp-config.php file is in the same directory"
	WPCONFIGPATH="wp-config.php"
fi


# Pick up DB credentials from the wp-config.php file specified
## Credits: Mark Jaquith
sqlname=`sed -n "s/.*\(['\"]\)DB_NAME\1\s*,\s*\(['\"]\)\(.*\)\2.*/\3/p" $WPCONFIGPATH`
sqluser=`sed -n "s/.*\(['\"]\)DB_USER\1\s*,\s*\(['\"]\)\(.*\)\2.*/\3/p" $WPCONFIGPATH`
sqlhost=`sed -n "s/.*\(['\"]\)DB_HOST\1\s*,\s*\(['\"]\)\(.*\)\2.*/\3/p" $WPCONFIGPATH`
sqlpass=`sed -n "s/.*\(['\"]\)DB_PASSWORD\1\s*,\s*\(['\"]\)\(.*\)\2.*/\3/p" $WPCONFIGPATH`

# Detect paths
MYSQL=$(which mysql)
AWK=$(which awk)
GREP=$(which grep)

# Collect all table names inside the database
TABLES=$($MYSQL -u $sqluser -p$sqlpass $sqlname -e 'show tables' | $AWK '{ print $1}' | $GREP -v '^Tables' )

# Iterate through them and delete one by one
for t in $TABLES
do
	echo "Deleting $t table from $sqlname database..."
	$MYSQL -u $sqluser -p$sqlpass $sqlname -e "drop table $t"
done

# Import back the database
echo "Now importing back the initial backup file: wp.sql"
$MYSQL -u $sqluser -p$sqlpass $sqlname < wp.sql

echo 'Done!'
