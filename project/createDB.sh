#! /usr/bin/bash


while  true; 
    do
        read -p "Enter Database name: " DBName
        if ! [[ "$DBName" =~ ^[a-zA-Z][a-zA-Z0-9]*$ ]]; 
            then
                echo "Invalid Database Name"
        elif [ -e $DBName ]; 
            then
                echo "This Database already exists"
        else 
            mkdir $DBName 
            echo "Database is created successfully"
        break
            fi
done

