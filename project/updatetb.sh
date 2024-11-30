#! /usr/bin/bash


source ~/project/utils.sh
get_table_name

update_primary_key() {
    if [[ ${upd_col_info[2]} == "pk" ]]; 
        then
        if [[ $is_none -eq 1 ]] || 
           [[ $(count_occurrences $input ${upd_col_info[0]}) -gt 0 ]] || 
           [[ $(count_occurrences $cond ${cond_col_info[0]}) -gt 1 ]]; 
            then
                echo -e "Unique constraint violated \n"
                . ~/project/tbmenu.sh	
                exit 1  # Exit with error code 1
            fi
        fi
}

update_table() {
    local cond="$1"
    local cond_col_num="$2"
    local update_col_num="$3"
    local new_val="$4"
    local is_none="$5"


    awk -v cond="$cond" -v col_num="$cond_col_num" -v update_col_num="$update_col_num" -v new_val="$new_val" -v is_none="$is_none" '
        BEGIN { FS = OFS = "," }
        {
            if ($col_num == cond || is_none==1) {
                $update_col_num = new_val
            }
            print
        }
    ' "$TBName" > "$TBName.temp" && mv "$TBName.temp" "$TBName"
}

while true; 
    do
        read -p "Enter column name that you want to update it: " upd_col
        upd_col_info=($(get_column_info "$upd_col"))
        if [[ -z $upd_col_info  ]]; 
            then
                echo "This column does not exist"
                continue
            fi
    break 
    done

while true; 
    do
        read -p "Enter the new value: " input
        if ! validate_input "$input" "${upd_col_info[1]}"; then
            echo 'invalid input type'
            continue
        fi  
    break  
    done


while true; 
    do
        is_none=0
        read -p "Enter column name for the condition or 'none': " cond_col
        if [[ $cond_col != "none" ]]; 
            then
                cond_col_info=($(get_column_info "$cond_col"))
                if [[ -z $cond_col_info ]]; 
                    then
                        echo "This column does not exist"
                        continue
                    fi

            read -p "Enter the condition: " cond
            if [[ -z $cond ]]; 
                then
                    echo "The condition could not be empty"
                    continue
                fi
        
 	    if [[ ${cond_col_info[1]} == "string" ]]; 
 	        then
                cond=$(echo "$cond" | sed 's/^"//;s/"$//')
	        fi
	
        else
	    cond_col_num=""
            cond=""
            is_none=1
            fi
    break
    done

update_primary_key

update_table "$cond" "${cond_col_info[0]}" "${upd_col_info[0]}" "$input" "$is_none"
    echo -e "Table updated successfully \n"
	
. ~/project/tbmenu.sh	
 
