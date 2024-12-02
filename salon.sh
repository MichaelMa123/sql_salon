#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --no-align --tuples-only -c"

echo "$($PSQL "SELECT service_id || ') '|| name FROM services")"
read SERVICE_ID_SELECTED

VALID_SERVICE_ID=$($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED;")
is_valid=1
while [[ $is_valid -eq 1 ]]
do
    VALID_SERVICE_ID=$($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED;")

    if [[ -z $VALID_SERVICE_ID ]]; then
        echo "I could not find that service. What would you like today?"
        echo "$($PSQL "SELECT service_id || ') '|| name FROM services")"
        read SERVICE_ID_SELECTED
    else
        is_valid=0
    fi
done
VALID_SERVICE=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED;")
echo "What's your phone number?"
read CUSTOMER_PHONE
CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE';")
    if [[ -z $CUSTOMER_NAME ]]; then
        echo "I don't have a record for that phone number, what's your name?"
        read CUSTOMER_NAME
        INSERT_RESULT=$($PSQL "INSERT INTO customers (name,phone) VALUES ('$CUSTOMER_NAME','$CUSTOMER_PHONE');")
        USER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE';")
        echo "What time would you like your $VALID_SERVICE, $CUSTOMER_NAME?"
        read SERVICE_TIME
        INSERT_RESULT=$($PSQL "INSERT INTO appointments (time,customer_id,service_id) VALUES ('$SERVICE_TIME',$USER_ID,$VALID_SERVICE_ID);")
        echo "I have put you down for a $VALID_SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
    else
        echo "What time would you like your $VALID_SERVICE, '$CUSTOMER_NAME'?"
        read SERVICE_TIME
        USER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE';")
        INSERT_RESULT=$($PSQL "INSERT INTO appointments (time,customer_id,service_id) VALUES ('$SERVICE_TIME',$USER_ID,$VALID_SERVICE_ID);")
        echo "I have put you down for a $VALID_SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
    fi