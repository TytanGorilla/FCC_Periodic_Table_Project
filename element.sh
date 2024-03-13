#!/bin/bash
# Check if no arguments were provided
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align --tuples-only -c"
if [ $# -eq 0 ]; 
then
  echo "Please provide an element as an argument."
else
  #Capture argument
  INPUT=$1

  #Check if INPUT is numeric
  if [[ $INPUT =~ ^[0-9]+$ ]]; then
    #Search database based on atomic number
    SEARCH_RESULT=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$INPUT")
  else
    #Search database based on symbol or name
    SEARCH_RESULT=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol ILIKE '$INPUT' OR name ILIKE '$INPUT'")
  fi

  #Check if SEARCH_RESULT is empty or not
  if [[ -z $SEARCH_RESULT ]]
  then
    echo "I could not find that element in the database."
  else
    echo "$SEARCH_RESULT" | while IFS="|" read ATOMIC_NO SYMBOL NAME TYPE ATOMIC_MASS MELTING_P BOILING_P
    do
      echo "The element with atomic number $ATOMIC_NO is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_P celsius and a boiling point of $BOILING_P celsius."
    done
  fi
fi
