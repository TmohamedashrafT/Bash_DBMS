#!/bin/bash




PS3="What do you want to do? "

select choice in "Create New Table" "List Current Tables" "Update Table " "Insert in Table" "Select From Table " "Delete From Table" "Drop Table " "exit"
 do
    case $REPLY in
        1) 
          
                echo "You selected to $choice"
               . ~/project/createTB.sh
               break
               ;;
               
         2) 
          
                echo "You selected to $choice"
               . ~/project/listtb.sh
               break
               ;;
	3) 
          
                echo "You selected to $choice"
               . ~/project/updatetb.sh
               break
               ;;
        4) 
          
                echo "You selected to $choice"
               . ~/project/insert.sh
               break
               ;;
        5) 
          
                echo "You selected to $choice"
               . ~/project/selectfromtb.sh
               break
               ;;
        6) 
          
                echo "You selected to $choice"
               . ~/project/deleteFTB.sh 
               break                    
          
            ;;
        7) 
          
                echo "You selected to $choice"
               . ~/project/droptb.sh      
               break                    
          
            ;;
            
       8)  	 
       		echo "You selected to $choice"
            	. ~/project/mainmenu.sh 
            	;;
        *)
          echo "Invalid Input. " 
            break
            ;;
    esac
done

