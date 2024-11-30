#! /usr/bin/bash

while true; 
    do
        read -p "Enter Database Name: " DBName
        if [[ -d $DBName ]]; 
            then 
                cd $DBName 
                echo $DBName Database is selected successfully
                . ~/project/tbmenu.sh
                break
        else
                echo "Database does not exist"
            fi
done
