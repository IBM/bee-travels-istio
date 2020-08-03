#!/bin/bash

dockerTag=57d4b5fdb837d1b7f05f2a9d451b4310309b95c5

mongoInitCreds() {
	read -p "  Database Connection URL: " mongoURL
	read -p "  Use SSL/TLS (Y/N): " usesTLS
	if [ "$usesTLS" = "Y" ] || [ "$usesTLS" = "y" ]; then
		read -p "  Certificate File Path: " mongoCertificatePath
		mongoCertificate=$(cat $mongoCertificatePath)
	else
		unset mongoCertificate
	fi
}

mongoCreds() {
	if [ "$mongoURL" ]; then
		read -p "  Use Existing Mongo Credentials (Y/N): " wantExistingMongoCreds
		if [ "$wantExistingMongoCreds" = "N" ] || [ "$wantExistingMongoCreds" = "n" ]; then
			mongoInitCreds
		fi
	else
		mongoInitCreds
	fi
}

postgresInitCreds() {
	read -p "  Host: " postgresHost
	read -p "  Port: " postgresPort
	read -p "  User: " postgresUser
	read -p "  Password: " postgresPassword
	read -p "  Use SSL/TLS (Y/N): " usesTLS
	if [ "$usesTLS" = "Y" ] || [ "$usesTLS" = "y" ]; then
		read -p "  Certificate File Path: " postgresCertificatePath
		postgresCertificate=$(cat $postgresCertificatePath)
		read -p "  Database: " postgresDB
	else
		unset postgresCertificate
	fi
}

postgresCreds() {
	if [ "$postgresHost" ]; then
		read -p "  Use Existing Postgres Credentials (Y/N): " wantExistingPostgresCreds
		if [ "$wantExistingPostgresCreds" = "N" ] || [ "$wantExistingPostgresCreds" = "n" ]; then
			postgresInitCreds
		fi
	else
		postgresInitCreds
	fi
}

couchInitCreds() {
	read -p "  Database Connection URL: " couchURL
}

couchCreds() {
	if [ "$couchURL" ]; then
		read -p "  Use Existing Couch/Cloudant Credentials (Y/N): " wantExistingCouchCreds
		if [ "$wantExistingCouchCreds" = "N" ] || [ "$wantExistingCouchCreds" = "n" ]; then
			couchInitCreds
		fi
	else
		couchInitCreds
	fi
}


echo "Welcome to the Bee Travels Data Generating Script"
echo "Please answer the following options to configure your data:"

echo ""
read -p "Destination Data (Y/N): " wantsDestinationData
if [ "$wantsDestinationData" = "Y" ] || [ "$wantsDestinationData" = "y" ]; then
	read -p "  Generate Destination Data (Y/N): " wantsGenerateDestinationData
	if [ "$wantsGenerateDestinationData" = "Y" ] || [ "$wantsGenerateDestinationData" = "y" ]; then
		generateDestinationData=true
	else
		generateDestinationData=false
	fi
	read -p "  Database (mongodb/postgres/couchdb/cloudant): " destinationDatabase
	if [ "$destinationDatabase" = "mongodb" ]; then
		mongoCreds
		echo ""
		echo "Starting Destination data process"
		if [ "$mongoCertificate" ]; then
			docker run --net host -e GENERATE_DATA=$generateDestinationData -e DATABASE=mongodb -e DATABASE_CERT="$mongoCertificate" -e MONGO_CONNECTION_URL=$mongoURL beetravels/data-gen-destination:$dockerTag
		else
			docker run --net host -e GENERATE_DATA=$generateDestinationData -e DATABASE=mongodb -e MONGO_CONNECTION_URL=$mongoURL beetravels/data-gen-destination:$dockerTag
		fi
	elif [ "$destinationDatabase" = "postgres" ]; then
		postgresCreds
		echo ""
		echo "Starting Destination data process"
		if [ "$postgresCertificate" ]; then
			docker run --net host -e GENERATE_DATA=$generateDestinationData -e DATABASE=postgres -e DATABASE_CERT="$postgresCertificate" -e PG_HOST=$postgresHost -e PG_PORT=$postgresPort -e PG_USER=$postgresUser -e PG_PASSWORD=$postgresPassword -e PG_DB=$postgresDB beetravels/data-gen-destination:$dockerTag
		else
			docker run --net host -e GENERATE_DATA=$generateDestinationData -e DATABASE=postgres -e PG_HOST=$postgresHost -e PG_PORT=$postgresPort -e PG_USER=$postgresUser -e PG_PASSWORD=$postgresPassword beetravels/data-gen-destination:$dockerTag
		fi
	elif [ "$destinationDatabase" = "couchdb" ] || [ "$destinationDatabase" = "cloudant" ]; then
		couchCreds
		echo ""
		echo "Starting Destination data process"
		docker run --net host -e GENERATE_DATA=$generateDestinationData -e DATABASE=couchdb -e COUCH_CONNECTION_URL=$couchURL beetravels/data-gen-destination:$dockerTag
	fi
	echo "Destination data process complete"
fi

echo ""
read -p "Hotel Data (Y/N): " wantsHotelData
if [ "$wantsHotelData" = "Y" ] || [ "$wantsHotelData" = "y" ]; then
	read -p "  Generate Hotel Data (Y/N): " wantsGenerateHotelData
	if [ "$wantsGenerateHotelData" = "Y" ] || [ "$wantsGenerateHotelData" = "y" ]; then
		generateHotelData=true
	else
		generateHotelData=false
	fi
	read -p "  Database (mongodb/postgres/couchdb/cloudant): " hotelDatabase
	if [ "$hotelDatabase" = "mongodb" ]; then
		mongoCreds
		echo ""
		echo "Starting Hotel data process"
		if [ "$mongoCertificate" ]; then
			docker run --net host -e GENERATE_DATA=$generateHotelData -e DATABASE=mongodb -e DATABASE_CERT="$mongoCertificate" -e MONGO_CONNECTION_URL=$mongoURL beetravels/data-gen-hotel:$dockerTag
		else
			docker run --net host -e GENERATE_DATA=$generateHotelData -e DATABASE=mongodb -e MONGO_CONNECTION_URL=$mongoURL beetravels/data-gen-hotel:$dockerTag
		fi
	elif [ "$hotelDatabase" = "postgres" ]; then
		postgresCreds
		echo ""
		echo "Starting Hotel data process"
		if [ "$postgresCertificate" ]; then
			docker run --net host -e GENERATE_DATA=$generateHotelData -e DATABASE=postgres -e DATABASE_CERT="$postgresCertificate" -e PG_HOST=$postgresHost -e PG_PORT=$postgresPort -e PG_USER=$postgresUser -e PG_PASSWORD=$postgresPassword -e PG_DB=$postgresDB beetravels/data-gen-hotel:$dockerTag
		else
			docker run --net host -e GENERATE_DATA=$generateHotelData -e DATABASE=postgres -e PG_HOST=$postgresHost -e PG_PORT=$postgresPort -e PG_USER=$postgresUser -e PG_PASSWORD=$postgresPassword beetravels/data-gen-hotel:$dockerTag
		fi
	elif [ "$hotelDatabase" = "couchdb" ] || [ "$hotelDatabase" = "cloudant" ]; then
		couchCreds
		echo ""
		echo "Starting Hotel data process"
		docker run --net host -e GENERATE_DATA=$generateHotelData -e DATABASE=couchdb -e COUCH_CONNECTION_URL=$couchURL beetravels/data-gen-hotel:$dockerTag
	fi
	echo "Hotel data process complete"
fi

echo ""
read -p "Car Rental Data (Y/N): " wantsCarData
if [ "$wantsCarData" = "Y" ] || [ "$wantsCarData" = "y" ]; then
	read -p "  Generate Car Rental Data (Y/N): " wantsGenerateCarData
	if [ "$wantsGenerateCarData" = "Y" ] || [ "$wantsGenerateCarData" = "y" ]; then
		generateCarData=true
	else
		generateCarData=false
	fi
	read -p "  Database (mongodb/postgres/couchdb/cloudant): " carDatabase
	if [ "$carDatabase" = "mongodb" ]; then
		mongoCreds
		echo ""
		echo "Starting Car Rental data process"
		if [ "$mongoCertificate" ]; then
			docker run --net host -e GENERATE_DATA=$generateCarData -e DATABASE=mongodb -e DATABASE_CERT="$mongoCertificate" -e MONGO_CONNECTION_URL=$mongoURL beetravels/data-gen-carrental:$dockerTag
		else
			docker run --net host -e GENERATE_DATA=$generateCarData -e DATABASE=mongodb -e MONGO_CONNECTION_URL=$mongoURL beetravels/data-gen-carrental:$dockerTag
		fi
	elif [ "$carDatabase" = "postgres" ]; then
		postgresCreds
		echo ""
		echo "Starting Car Rental data process"
		if [ "$postgresCertificate" ]; then
			docker run --net host -e GENERATE_DATA=$generateCarData -e DATABASE=postgres -e DATABASE_CERT="$postgresCertificate" -e PG_HOST=$postgresHost -e PG_PORT=$postgresPort -e PG_USER=$postgresUser -e PG_PASSWORD=$postgresPassword -e PG_DB=$postgresDB beetravels/data-gen-carrental:$dockerTag
		else
			docker run --net host -e GENERATE_DATA=$generateCarData -e DATABASE=postgres -e PG_HOST=$postgresHost -e PG_PORT=$postgresPort -e PG_USER=$postgresUser -e PG_PASSWORD=$postgresPassword beetravels/data-gen-carrental:$dockerTag
		fi
	elif [ "$carDatabase" = "couchdb" ] || [ "$carDatabase" = "cloudant" ]; then
		couchCreds
		echo ""
		echo "Starting Car Rental data process"
		docker run --net host -e GENERATE_DATA=$generateCarData -e DATABASE=couchdb -e COUCH_CONNECTION_URL=$couchURL beetravels/data-gen-carrental:$dockerTag
	fi
	echo "Car Rental data process complete"
fi

echo ""
echo "WARNING: Flight Data might take a long time to upload"
read -p "Flight Data (Y/N): " wantsFlightData
if [ "$wantsFlightData" = "Y" ] || [ "$wantsFlightData" = "y" ]; then
	read -p "  Generate Flight Data (Y/N): " wantsGenerateFlightData
	if [ "$wantsGenerateFlightData" = "Y" ] || [ "$wantsGenerateFlightData" = "y" ]; then
		generateFlightData=true
	else
		generateFlightData=false
	fi
	read -p "  Database (mongodb/postgres/couchdb/cloudant): " flightDatabase
	if [ "$flightDatabase" = "mongodb" ]; then
		mongoCreds
		echo ""
		echo "Starting Flight data process"
		if [ "$mongoCertificate" ]; then
			docker run --net host -e GENERATE_DATA=$generateFlightData -e DATABASE=mongodb -e DATABASE_CERT="$mongoCertificate" -e MONGO_CONNECTION_URL=$mongoURL beetravels/data-gen-airports:$dockerTag
		else
			docker run --net host -e GENERATE_DATA=$generateFlightData -e DATABASE=mongodb -e MONGO_CONNECTION_URL=$mongoURL beetravels/data-gen-airports:$dockerTag
		fi
	elif [ "$flightDatabase" = "postgres" ]; then
		postgresCreds
		echo ""
		echo "Starting Flight data process"
		if [ "$postgresCertificate" ]; then
			docker run --net host -e GENERATE_DATA=$generateFlightData -e DATABASE=postgres -e DATABASE_CERT="$postgresCertificate" -e PG_HOST=$postgresHost -e PG_PORT=$postgresPort -e PG_USER=$postgresUser -e PG_PASSWORD=$postgresPassword -e PG_DB=$postgresDB beetravels/data-gen-airports:$dockerTag
		else
			docker run --net host -e GENERATE_DATA=$generateFlightData -e DATABASE=postgres -e PG_HOST=$postgresHost -e PG_PORT=$postgresPort -e PG_USER=$postgresUser -e PG_PASSWORD=$postgresPassword beetravels/data-gen-airports:$dockerTag
		fi
	elif [ "$flightDatabase" = "couchdb" ] || [ "$flightDatabase" = "cloudant" ]; then
		couchCreds
		echo ""
		echo "Starting Flight data process"
		docker run --net host -e GENERATE_DATA=$generateFlightData -e DATABASE=couchdb -e COUCH_CONNECTION_URL=$couchURL beetravels/data-gen-airports:$dockerTag
	fi
	echo "Flight data process complete"
fi

echo ""
echo "Data generation process complete"