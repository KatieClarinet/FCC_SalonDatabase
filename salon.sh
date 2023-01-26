#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c "
echo -e "\n~~~~~ MY SALON ~~~~~\n"

echo -e "Welcome to My Salon, how can I help you?"

SERVICES() {
# display list of services
AVAILABLE_SERVICES=$($PSQL "SELECT * FROM services")
echo "$AVAILABLE_SERVICES" | while read SERVICE_ID BAR NAME
do
echo "$SERVICE_ID) $NAME"
done
}

SELECT_SERVICE() {
# select a service
read SERVICE_ID_SELECTED 
CHECK_ID_VALID=$($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED;")
echo "$CHECK_ID_VALID"
if [[ ! $CHECK_ID_VALID ]]
then
#  GET_CUSTOMER_INFO
#  else
 echo "I could not find that service. What would you like today?" 
 SERVICES
 SELECT_SERVICE
fi
}
SERVICES
SELECT_SERVICE
GET_CUSTOMER_INFO() {
echo -e "What's your phone number?"
read CUSTOMER_PHONE
#check if phone number in system
CUSTOMER_NUMBER=$($PSQL "SELECT phone FROM customers WHERE phone = '$CUSTOMER_PHONE'")
# echo "CUSTOMER NUMBER: $CUSTOMER_NUMBER"
if [[ -z $CUSTOMER_NUMBER ]]
then
echo -e "I don't have a record for that phone number, what's your name?"
read CUSTOMER_NAME
INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(phone, name) VALUES ('$CUSTOMER_PHONE', '$CUSTOMER_NAME');")
fi
CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
SERVICE=$($PSQL "SELECT name FROM services WHERE service_id = '$SERVICE_ID_SELECTED';")
echo "What time would you like your $(echo $SERVICE | sed -E 's/^ *| *$//g'), $(echo $CUSTOMER_NAME | sed -E 's/^ *| *$//g')?"
read SERVICE_TIME
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
INSERT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES ('$CUSTOMER_ID', '$SERVICE_ID_SELECTED', '$SERVICE_TIME')")
echo -e "I have put you down for a $(echo $SERVICE | sed -E 's/^ *| *$//g') at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed -E 's/^ *| *$//g')."
 }
 
GET_CUSTOMER_INFO
