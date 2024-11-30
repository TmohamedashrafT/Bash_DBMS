#! /usr/bin/bash


source ~/project/utils.sh
get_table_name


while true;
    do
        read -p "Enter column name or all: " Col
        if  [[ $Col == "all" ]] ; 
            then
                > $TBName
                echo "All contents of the table were deleted"
        else 
                col_num=$(awk -v input_col="$Col" 'BEGIN{FS=","}{if (input_col== $1) 
                {print NR; exit }}' "${TBName}.meta")
                if [[ -z $col_num  ]]; 
                    then
                        echo "This column does not exist"
                        continue
                    fi
                read -p "Enter the condition: " cond
                awk -v cond="$cond" -v col_num="$col_num" 'BEGIN { FS="," } { if ($col_num != cond) { print $0 } }' "$TBName" > "$TBName.temp" && mv "$TBName.temp" "$TBName"
                echo "Rows that match the condition were deleted."
            fi
    break
    done
echo 
. ~/project/tbmenu.sh	
    
