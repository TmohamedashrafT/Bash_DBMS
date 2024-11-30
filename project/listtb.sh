#!/bin/bash
echo "Available Tables:"

i=1
for tb in *;
    do
        if ! [[ "$tb" =~ \.meta$ ]]; 
            then
                echo "$i- $tb"
                ((i++))
            fi
    done
echo
. ~/project/tbmenu.sh	

