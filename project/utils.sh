#! /usr/bin/bash

get_table_name(){
    while true; 
        do
            read -p 'Enter table name: ' TBName
            if ! [[ "$TBName" =~ ^[a-zA-Z][a-zA-Z0-9_]*$ ]]; 
                then
                    echo "Invalid Table Name"
            elif [ ! -e $TBName  ]; 
                then
                    echo "This table does not exist"
            elif [ ! -e "${TBName}.meta" ]; 
                then
                    echo "There is a problem in this table"
            else
                    break
                fi 
        done
}

get_column_info() {
    local column_name="$1"
    awk -v input_col="$column_name" '
        BEGIN { FS="," }
        { if (input_col == $1) { print NR, $2, $3; exit } }
    ' "$TBName.meta"
}

validate_input() {
    input=$1
    local column_type=$2
    if ! { 
        [[ "$column_type" == "int" && $input =~ ^[1-9][0-9]*$ ]] || 
        [[ "$column_type" == "string" && $input =~ ^\".*\"$ && ! $input =~ , ]]
    }; 
        then
            return 1
        fi
    if [[ $column_type == "string" ]]; 
        then
            input=$(echo "$input" | sed 's/^"//;s/"$//')
        fi
    return 0
}

get_condition_column() {
    local column_name="$1"
    local table_meta="${TBName}.meta"
    awk -v cond_col="$column_name" '
        BEGIN { FS="," }
        { if (cond_col == $1) { print NR; exit } }
    ' "$table_meta"
}

count_occurrences() {
     local input="$1"
     local column_index="$2"
     cnt=$(cut -d, -f  $column_index $TBName | grep $input -c -w)
     echo $cnt
}

check_primary_key() {
   
        dup_pk=$(awk -v input="$input" -v col="$((column_index))" '
            BEGIN { FS = "," }
            { if ($col == input) { print "yes"; exit } }
        ' "${TBName}")

        if [[ $dup_pk == "yes" ]]; then
            echo "Value $input already exists in the primary key column ${columns[column_index]}"
            return 1
        fi
    return 0
}
