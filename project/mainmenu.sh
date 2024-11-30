#!/bin/bash

if [[ ! -d "$HOME/Databases" ]]; then
     mkdir ~/Databases
fi
cd ~/Databases

PS3="What do you want to do? "
echo "========== Main Menu =========="

select choice in "Create New Database" "Connect to Database" "List Current Databases" "Drop Database "  "exit"
 do
    case $REPLY in
        1) 
          
                echo "You selected to $choice"
                . ~/project/createDB.sh
               break
               ;;
        2) 
          
                echo "You selected to $choice"
               . ~/project/selectDB.sh
               break
               ;;
               
         3) 
          
                echo "You selected to $choice"
               . ~/project/listdb.sh
               break
               ;;

        4) 
          
                echo "You selected to $choice"
               . ~/project/dropdb.sh
               break
               ;;
       
       5)  	 
       		echo "You selected to $choice"
       		echo "exiting..."	
            	break
            	;;
        *)
          echo  "Invalid Input. Please enter a number between 1-5."
            continue
            ;;
    esac
done

