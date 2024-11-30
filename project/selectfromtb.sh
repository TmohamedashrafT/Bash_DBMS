#!/bin/bash


select_columns_by_name() {
    local cols=$1
    local all_col_names=($(awk -F, '{print $1}' "${TBName}.meta"))
    local selected_headers=""
    local col_nums=""

    IFS=',' read -r -a col_names <<< "$cols"

    for col_name in "${col_names[@]}"; do
        local col_index=0
        local found=false
        for header_col in "${all_col_names[@]}"; do
            ((col_index++))
            if [[ "$header_col" == "$col_name" ]]; then
                selected_headers+="$col_name,"
                col_nums+="$col_index,"
                found=true
                break
            fi
        done
        if ! $found; then
            echo "Error: Column '$col_name' does not exist."
            return 1
        fi
    done

    selected_headers=${selected_headers%,}
    col_nums=${col_nums%,}

    echo "$selected_headers"
    echo "$col_nums"
}

source ~/project/utils.sh
get_table_name




select option in "Show Column Names" "Select All Columns" "Select Specific Columns" "Exit"; do
    case $option in

        "Show Column Names")
            awk -F, '{print NR, $1}' "${TBName}.meta"
            ;;

        "Select All Columns")
            while true; do
                read -p "Do You Want to Apply Where Condition? [y/n]: " wcond
                if [[ $wcond =~ ^[Nn]$ ]]; then
                    headers=$(awk -F, '{print $1}' "${TBName}.meta" | paste -sd, | awk -F, '{for (i=1; i<=NF; i++) printf "%-15s", $i; print ""}')
                    echo "$headers"
                    echo "----------------------------------------------------------------------------"
                    awk -F, '{for (i=1; i<=NF; i++) printf "%-15s", $i; print ""}' "$TBName"
                    break
                elif [[ $wcond =~ ^[Yy]$ ]]; then
                    read -p "Please Enter Your Condition (e.g., column_name = value): " wcol

                   if ! [[ $wcol =~ ^[A-Za-z0-9_]+[[:space:]]+(=|!=|>=|<=|>|<)[[:space:]]+.*$ ]]; then
   				 echo "Invalid Condition"
   				 continue
			fi

                    column_name=$(echo "$wcol" | cut -d' ' -f1)
                    operator=$(echo "$wcol" | cut -d' ' -f2)
                    column_value=$(echo "$wcol" | cut -d' ' -f3)
                    col_num=$(awk -F, -v col="$column_name" '{if ($1 == col) {print NR; exit}}' "${TBName}.meta")
                    
                   

                    if [[ -n $col_num ]]; then
                        headers=$(awk -F, '{print $1}' "${TBName}.meta" | paste -sd, | awk -F, '{for (i=1; i<=NF; i++) printf "%-15s", $i; print ""}')
                        echo "$headers"
                        echo "----------------------------------------------------------------------------"
                        awk -F, -v col="$col_num" -v op="$operator" -v val="$column_value" '
                        {
                            condition_met = 0;
                            if (op == "=" && $col == val) condition_met = 1;
                            else if (op == "!=" && $col != val) condition_met = 1;
                            else if (op == ">" && $col > val) condition_met = 1;
                            else if (op == "<" && $col < val) condition_met = 1;
                            else if (op == ">=" && $col >= val) condition_met = 1;
                            else if (op == "<=" && $col <= val) condition_met = 1;

                            if (condition_met) {
                                for (i=1; i<=NF; i++) printf "%-15s", $i;
                                print ""
                            }
                        }' "$TBName"
                        break
                    else
                        echo "Error: Column '$column_name' does not exist.make sure to put >Spaces< before and after the operator."
                    fi
                else
                    echo "Invalid option. Please choose [y/n]."
                    
                fi
            done
            ;;

        "Select Specific Columns")
            echo "Selecting specific columns by name."
            read -p "Which columns do you want to select (e.g., col1,col2): " cols
            if ! [[ "$cols" =~ ^([a-zA-Z0-9_]+)(,([a-zA-Z0-9_]+))*$ ]]; then
    		echo "Invalid Column Name"
    		else
            output=$(select_columns_by_name "$cols")
            if [[ $? -ne 0 ]]; then
            echo "invalid column name.."
                continue
            fi

            selected_headers=$(echo "$output" | head -1)
            col_nums=$(echo "$output" | tail -1)

            read -p "Do You Want to Apply Where Condition? [y/n]: " wcond
            

            if [[ $wcond =~ ^[Nn]$ ]]; then
                echo "$selected_headers" | awk -F, '{for (i=1; i<=NF; i++) printf "%-15s", $i; print ""}'
                echo "----------------------------------------------------------------------------"
                cut -d, -f"$col_nums" "$TBName" | awk -F, '{for (i=1; i<=NF; i++) printf "%-15s", $i; print ""}'
            elif [[ $wcond =~ ^[Yy]$ ]]; then
                read -p "Please Enter Your Condition (e.g., column_name = value): " wcol
               if ! [[ $wcol =~ ^[A-Za-z0-9_]+[[:space:]]+(=|!=|>=|<=|>|<)[[:space:]]+.*$ ]]; then
   				 echo "Invalid Condition"
   				 continue
			fi
                column_name=$(echo "$wcol" | cut -d' ' -f1)
                operator=$(echo "$wcol" | cut -d' ' -f2)
                column_value=$(echo "$wcol" | cut -d' ' -f3)
                col_num=$(awk -F, -v col="$column_name" '{if ($1 == col) {print NR; exit}}' "${TBName}.meta")

                if [[ -n $col_num ]]; then
                    echo "$selected_headers" | awk -F, '{for (i=1; i<=NF; i++) printf "%-15s", $i; print ""}'
                    echo "----------------------------------------------------------------------------"
                    awk -F, -v col="$col_num" -v op="$operator" -v val="$column_value" -v col_nums="$col_nums" '
                    BEGIN { split(col_nums, cols, ",") }
                    {
                        condition_met = 0;
                        if (op == "=" && $col == val) condition_met = 1;
                        else if (op == "!=" && $col != val) condition_met = 1;
                        else if (op == ">" && $col > val) condition_met = 1;
                        else if (op == "<" && $col < val) condition_met = 1;
                        else if (op == ">=" && $col >= val) condition_met = 1;
                        else if (op == "<=" && $col <= val) condition_met = 1;

                        if (condition_met) {
                            for (i in cols) printf "%-15s", $cols[i];
                            print "";
                        }
                    }' "$TBName"
                else
                    echo "Error: Column '$column_name' does not exist.make sure to put >Spaces< before and after the operator."
                fi
            else
                echo "Invalid option. Please choose [y/n]."
            fi
            fi
            ;;

        "Exit")
            echo "Exiting..."
            break
            ;;

        *)
            echo "Invalid option. Please choose a valid selection."
            ;;
    esac
done

