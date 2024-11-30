#! /usr/bin/bash
source ~/project/utils.sh


get_table_name

columns=($(awk 'BEGIN{FS=","}{print $1}' "${TBName}.meta"))
column_type=($(awk 'BEGIN{FS=","}{print $2}' "${TBName}.meta"))
pk_col=($(awk 'BEGIN{FS=","}{if ($3=="pk")print $1}' "${TBName}.meta"))

line=""
for (( i=0; i<${#columns[@]}; i++ )); 
    do
        while true; 
            do
                read -p "Enter ${columns[i]}: " input
                if ! validate_input "$input" "${column_type[i]}"; then
                    echo 'invalid input type'
                    continue
                fi    

                if [[ ${columns[i]} == "$pk_col" ]]; 
                    then
	                if [[ $(count_occurrences $input $((i+1))) -gt 0 ]]; 
	                    then
	    	                echo -e "Unique constraint violated \n"
		                continue
	                    fi
                    fi
                if [[ $i -eq  $((${#columns[@]}-1)) ]]; 
                    then
                        line+=$input
                else 
                        line+=$input,
                    fi
            break	
            done
    done 
    
echo $line >> "${TBName}"
echo -e "Data has been successfully added to the table '$TBName'. \n"
. ~/project/tbmenu.sh	


