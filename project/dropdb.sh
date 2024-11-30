#!/bin/bash


PS3="Which DB do you want to drop? "

select db in $(ls); do
    case $REPLY in
        *) 
          if [ -d "$db" ]; 
              then
                  echo "You selected: $db"
                  read -p "Are you sure you want to Drop '$db'? [Y/N]: " confirm
                  if [[ $confirm == [yY] ]];
                      then
                        rm -r "$db"
                        echo "DB $db has been Dropped Successfully!"
                  elif [[ $confirm == [nN] ]]; 
                      then
                          echo "Drop cancelled."
                 else
               		 echo "Invalid Input. "
                      fi
          else
                echo "Invalid Name. Please try again."
              fi
            ;;
    esac
done



