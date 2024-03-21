ls -al flights.csv
head flights.csv
tail flights.csv
wc flights.csv

awk --field-separator=';' '$9 ~ /??.4.2016/ {print $4 " " $5 " " $9}' flights.csv | uniq -c
