#!/bin/bash
# Will dump all databases separatelly and gzip compress them

# If BACK_HOUR is set, check that it matches
if [[ "$BACK_HOUR" != "" ]]; then
	NOW_HOUR=$(date "+%-H")
	if ((NOW_HOUR != BACK_HOUR)); then
		echo "Backup will run at $BACK_HOUR. Right now is: $NOW_HOUR"
		exit 0
	fi
fi

STOREIN="/home"
CHARSET="UTF8"

MYSQLPW=" -u${DB_USER} -p${DB_PASS} -h${DB_HOST} "
MYSQLPM=" --hex-blob --comments=false --default-character-set=${CHARSET} "

rm -f "${STOREIN}"/*.gz
while read -r DB; do
	if [[ "$DB" != "mysql" && "$DB" != "information_schema" && "$DB" != "sys" && "$DB" != "performance_schema" ]]; then
		echo "Processing [$DB] ... "
		mysqldump ${MYSQLPW} ${MYSQLPM} ${DB} -r "${STOREIN}/$DB.sql"
		gzip "${STOREIN}/$DB.sql"
	fi
done < <(mysql ${MYSQLPW} -Bse 'show databases')

exit 0
