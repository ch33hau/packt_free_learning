#!/bin/bash

export PATH=/bin:/usr/bin:$PATH

# Login Credentials
USERNAME=""
PASSWORD=""
CREDENTIALS_FILE="$HOME/.packt"

# Options
DOWNLOAD=$PACKT_DOWNLOAD
DOWNLOAD_PATH="$HOME/packt"

# Log running information
echo "Date: $(date)"

if [ -z "$DOWNLOAD" ]; then
	DOWNLOAD="Y"
fi

if [ -f $CREDENTIALS_FILE ];
then
	credentials_base64=`cat $CREDENTIALS_FILE`
	credentials=`echo $credentials_base64 | base64 --decode`
	USERNAME=`echo $credentials | awk -F":" '{print $1}'`
	PASSWORD=`echo $credentials | awk -F":" '{print $2}'`
fi

if [ -z "$USERNAME" ] || [ -z $PASSWORD ]
then
	echo "Please enter your Packt username (email): "
	read USERNAME
	echo "Please enter your Packt password: "
	read PASSWORD
	credentials_base64=`echo "$USERNAME:$PASSWORD" | base64`
	echo $credentials_base64 > $CREDENTIALS_FILE
	echo "Your credentials was saved to $CREDENTIALS_FILE in base64 encoded format."
fi

# Constant
TMP_FILE="/tmp/free-learning.txt"
URL_LOGIN="https://www.packtpub.com"
COMMAND_LOGIN="curl -s -i -X POST -d email=$USERNAME&password=$PASSWORD&op=Login&form_id=packt_user_login_form $URL_LOGIN"

URL_FREE_LEARNING="https://www.packtpub.com/packt/offers/free-learning"
COMMAND_FREE_LEARNING="curl -s -X GET $URL_FREE_LEARNING"

response_login=$($COMMAND_LOGIN > $TMP_FILE)
login_cookie=$(cat $TMP_FILE | grep Set-Cookie | tail -1 | grep -Po "Set-Cookie: (\w*=*\w*)" | cut -d\  -f2)

response_freelearning=$($COMMAND_FREE_LEARNING)
book_title=$(echo $response_freelearning | grep -Po "(?<=<div class=\"dotd-title\"> <h2> )[\w .]+(?= <\/h2> <\/div>)")
book_href=$(echo $response_freelearning | grep -Po "(?<=<a href=\")[\w \/-]+(?=\" class=\"twelve-days-claim\")")
book_number=$(echo $book_href | cut -d/ -f3)
book_url=$URL_LOGIN$book_href

echo "Today's free book: $book_title"
echo "Claim url: $book_url"
COMMAND_CLAIM_FREE_BOOK="curl -i -s --cookie $login_cookie $book_url"

$COMMAND_CLAIM_FREE_BOOK > /dev/null 2>&1

if [ "Y" = "$DOWNLOAD" ]; then
	mkdir -p $DOWNLOAD_PATH

	URL_DOWNLOAD_BOOK="https://www.packtpub.com/ebook_download/$book_number/pdf"
	BOOK_LOCATION="$DOWNLOAD_PATH"/"$book_title".pdf
	COMMAND_DOWNLOAD_BOOK="curl -s -i --cookie $login_cookie $URL_DOWNLOAD_BOOK"

	echo "Downloading to $BOOK_LOCATION..."
	$COMMAND_DOWNLOAD_BOOK > "$BOOK_LOCATION"
	echo "Downloaded to $BOOK_LOCATION"
else
	echo "Free book has added to your Packt account."
fi
