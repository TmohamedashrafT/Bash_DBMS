#! /bin/bash
echo "Available Databases:"

i=1
for db in `ls`
    do
        echo $i"- "$db
        ((i++))
done

