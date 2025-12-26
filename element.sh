#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

USER_ARG=$1

if [[ -z $USER_ARG ]]
then
echo "Please provide an element as an argument." 
else
if [[ $USER_ARG =~  ^[0-9]+$ ]]
then
ELEMENT=$($PSQL "SELECT e.atomic_number, e.name, t.type, e.symbol, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements AS e LEFT JOIN properties AS p USING(atomic_number) LEFT JOIN types AS t on p.type_id = t.type_id WHERE e.atomic_number = $USER_ARG;")
else
ELEMENT=$($PSQL "SELECT e.atomic_number, e.name, t.type, e.symbol, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements AS e LEFT JOIN properties AS p USING(atomic_number) LEFT JOIN types AS t ON p.type_id = t.type_id WHERE e.symbol = '$USER_ARG' OR e.name = '$USER_ARG';")
fi

if [[ -z $ELEMENT ]]
then
echo "I could not find that element in the database."
else 
echo "$ELEMENT" | while read ATOMIC_NUMBER BAR NAME BAR TYPE BAR SYMBOL BAR MASS BAR MELTING BAR BOILING
do
echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
done
fi

fi 
