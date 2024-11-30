#! /usr//bin/bash

source ~/project/utils.sh
get_table_name

echo -n "Are you sure you want to drop the table '$TBName'? (y/n): "
read -r confirm
if [[ $confirm =~ ^[Yy]$ ]]; 
    then
         rm -r "$TBName"
         rm "${TBName}.meta"
         echo "Table '$TBName' has been dropped successfully."
else
         echo "Table drop operation canceled."
    fi
    
echo 

. ~/project/tbmenu.sh	
