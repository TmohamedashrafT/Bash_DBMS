#!/usr/bin/bash

source ~/project/utils.sh

while true; 
    do
        read -p 'Enter table name: ' TBName
        if ! [[ "$TBName" =~ ^[a-zA-Z][a-zA-Z0-9_]*$ ]]; 
            then
                echo "Invalid Table Name"
        elif [  -f $TBName ]; 
            then
                echo "This table already exists"
        else
                break
            fi 
    done


while true; 
    do
        read -p "Enter number of columns: " No_of_columns
        if [[ ! "$No_of_columns" =~ ^[1-9][0-9]*$ ]]; 
            then
                echo "Invalid number"
        else 
                break
            fi
    done 

columns=()
col_types=()
PKflag=0

for ((i = 0; i < No_of_columns; i++)); 
    do 
        while true;
            do
            read -p "Enter Column name: " ColName
            if ! [[ "$ColName" =~ ^[a-zA-Z][a-zA-Z0-9_]*$ ]]; 
                then
                    echo "Invalid Column Name"
                    continue
                fi
            break
            done

        for col in "${columns[@]}";
            do
                if [[ "${ColName,,}" == "${col,,}" ]]; 
                    then
                        echo "Column names should be unique"
                        . ~/project/createTB.sh
                        exit 0
                fi
            done

        while true; 
            do
                read -p "Enter column Datatype (int/string): " ColType
                colType_lower="${ColType,,}"
                if [[ "$colType_lower" != "int" && "$colType_lower" != "string" ]]; 
                    then 
                        echo "Column Datatype should be int or string" 
                else 
                        break
                    fi
            done


        colType_lower+=","
        if [[ "$PKflag" -eq 0 ]]; 
            then
                read -p "Do you want to make this Column PK (yes/no) " isPk
                if [[ "yes" == "$isPk" ]]; 
                    then
                        colType_lower+="pk"
                        PKflag=1
                    fi
            fi

        columns+=("$ColName")
        col_types+=("$colType_lower")
    done

touch "$TBName"
touch ${TBName}.meta

for ((i = 0; i < "$No_of_columns"; i++)); 
    do 
        echo "${columns[i]},${col_types[i]}" >> "${TBName}.meta"
    done

echo -e "$TBName Table is created successfully \n"

. ~/project/tbmenu.sh	

