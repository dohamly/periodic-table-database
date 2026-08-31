#! /bin/bash
# This script looks up element information from the periodic_table database

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ELEMENT_INFO=$($PSQL "SELECT atomic_number, symbol, name FROM elements WHERE atomic_number=$1")
  else
    ELEMENT_INFO=$($PSQL "SELECT atomic_number, symbol, name FROM elements WHERE symbol='$1' OR name='$1'")
  fi

  if [[ -z $ELEMENT_INFO ]]
  then
    echo "I could not find that element in the database."
  else
    ATOMIC_NUMBER=$(echo $ELEMENT_INFO | cut -d'|' -f1)
    SYMBOL=$(echo $ELEMENT_INFO | cut -d'|' -f2)
    NAME=$(echo $ELEMENT_INFO | cut -d'|' -f3)

    PROPERTIES_INFO=$($PSQL "SELECT atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM properties JOIN types ON properties.type_id = types.type_id WHERE atomic_number=$ATOMIC_NUMBER")

    ATOMIC_MASS=$(echo $PROPERTIES_INFO | cut -d'|' -f1)
    MELTING_POINT=$(echo $PROPERTIES_INFO | cut -d'|' -f2)
    BOILING_POINT=$(echo $PROPERTIES_INFO | cut -d'|' -f3)
    TYPE=$(echo $PROPERTIES_INFO | cut -d'|' -f4)

    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  fi
fi
