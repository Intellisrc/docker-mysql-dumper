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

SSL=""
if [[ "$DB_SSL" == "true" ]]; then
	SSL="--ssl"
fi
PWD=""
if [[ "$DB_PASS" != "" ]]; then
	PWD="-p${DB_PASS}"
fi

MYSQLPW="-u${DB_USER:-root} ${PWD} -h${DB_HOST:-localhost} -P${DB_PORT:-3306}"
MYSQLPM="--hex-blob --comments=false --default-character-set=${CHARSET} $SSL"

# Clean old files
find $STOREIN -type f -name "*.gz" -mtime +30 -delete
while read -r DB; do
	case $DB in
		mysql|MYSQL|information_schema|INFORMATION_SCHEMA|sys|SYS|performance_schema|PERFORMANCE_SCHEMA);;
		*)
			echo "Processing [$DB] ... "
			mysqldump ${MYSQLPW} ${MYSQLPM} ${DB} -r "${STOREIN}/$DB.sql"
			rm -f "${STOREIN}/$DB.sql.gz"
			gzip "${STOREIN}/$DB.sql";;
	esac
done < <(mysql ${MYSQLPW} -Bse 'show databases')

exit 0
