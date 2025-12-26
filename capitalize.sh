#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

echo -e "\nRun script to capitalize first letter of elements.symbol values.\n"
echo -e "The following are the elements that have the first character for symbol in lower case.\n"

CHECKER=$($PSQL "SELECT symbol, name FROM elements WHERE symbol ~ '^[a-z]';")
if [[ -z $CHECKER ]]
then
  echo "No elements found with lowercase starting symbols."
  exit 0
fi
echo "$CHECKER" | while read LOWER_SYMBOL BAR NAME
do
  echo "$LOWER_SYMBOL - $NAME"
done
echo -e "\nConfirm conversion to uppercase (y/n)?"
read CHOICE
if [[ $CHOICE = 'y' ]]
then 
  echo -e "\nUpdating symbols...\n"
  # Update all symbols that start with lowercase
  UPDATE_RESULT=$($PSQL "UPDATE elements SET symbol = UPPER(SUBSTRING(symbol, 1, 1)) || SUBSTRING(symbol, 2) WHERE symbol ~ '^[a-z]';")
  # Show the updated symbols
  echo -e "Updated symbols:\n"
  UPDATED=$($PSQL "SELECT symbol, name FROM elements WHERE symbol ~ '^[A-Z]' AND atomic_number IN (SELECT atomic_number FROM elements);")
  # Count how many were updated
  COUNT=$(echo "$UPDATE_RESULT" | grep -o '[0-9]\+')
  echo -e "Successfully converted $COUNT symbol(s) to proper case.\n"
else
  echo -e "\nConversion cancelled.\n"
fi