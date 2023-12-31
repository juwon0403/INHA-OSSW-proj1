#!/bin/bash

echo "-----------------------"
echo "User Name: Jeon Juwon"
echo "Student Number: 12211684"
echo "[ MENU ]"
echo "1. Get the data of the movie identified by a specific 'movie id' from 'u.item'"
echo "2. Get the data of action genre movies from 'u.item'"
echo "3. Get the average 'rating' of the movie identified by a specific 'movie id' from 'u.data'"
echo "4. Delete the 'IMDb URL' from 'u.item'"
echo "5. Get the data about users from 'u.user'"
echo "6. Modify the format of 'release date' in 'u.item'"
echo "7. Get the data of movies rated by a specific 'user id' from 'u.data'"
echo "8. Get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'"
echo "9. Exit"
echo "-----------------------"

u_item="$1"
u_data="$2"
u_user="$3"

while  true; do
	read -p "Enter your choice [1-9] " choice

	echo ""

	case $choice in
		1)
			read -p "Please enter 'movie id' (1~1682): " a1
			echo ""
			awk -F"|" -v movie_id="$a1" '$1 == movie_id {print}' "$u_item"
			echo ""
			;;
		2)
			read -p "Do you want to get the data of 'action' genre movies from 'u.item'?(y/n): " a2
			echo ""
			if [ "$a2" = "y" ]; then
				awk -F"|" '$7 == 1 {print $1, $2}' "$u_item" | head -n 10
			fi
			echo ""
			;;
		3)
			read -p "Please enter the 'movie id' (1~1682): " a3
			echo ""
			average_rating=$(awk -F"|" -v movie_id="$a3" 'BEGIN {sum=0; count=0} $2 == movie_id {sum+=$3; count++} END {if (count>0) {result=sum/count; printf "%.5f\n", result}}' "$u_data")
			echo "average rating of $a3: $average_rating"
			echo ""
			;;
		4)
			read -p "Do you want to delete the 'IMDb URL' from 'u.item'?(y/n): " a4
			echo ""
			if [ "$a4" = "y" ]; then
				sed 's/|http:[^|]*|/||/g' "$u_item" | head -n 10
			fi
			echo ""
			;;
		5)
			read -p "Do you want to get the data about users from 'u.user'?(y/n): " a5
			echo ""
			if [ "$a5" = "y" ]; then
				awk -F"|" '{print "user " $1 " is " $2 " years old " $3 " " $4}' "$u_user" | head -n 10
			fi
			echo ""
			;;
		6)
			read -p "Do you want to Modify the format of 'release date' in 'u.item'?(y/n): " a6
			echo ""
			if [ "$a6" = "y" ]; then
				sed -r 's/([0-9]+)-([A-Za-z]+)-([0-9]+)/\3\2\1/'
			fi
			echo ""
			;;
		7)
			read -p "Please enter the 'user id' (1~943): " a7
			echo ""
			movies=$(awk -F"|" -v user_id="$a7" '$1 == user_id {print $2}' "$u_data" | tr '\n' '|')
			echo "$movies" | tr '\n' '|' | tr -d ' '
			echo ""
			awk -F"|" -v movie_id="$movies" -v OFS="|" '$1 ~ "(" movie_id ")" {print $1, $2}' "$u_item"
			echo ""
			;;
		8)
			read -p "Do you want to get the average 'rating' of movies rated by users with age between 20 and 29 and occupation as 'programmer'?(y/n): " a8
			echo ""
			if [ "$a8" = "y" ]; then
				users=$(awk -F"|" '$2 >= 20 && $2 <= 29 && $4 == "programmer"' "$u_user")
				average_rating=$(awk -F"|" -v user_id="$users" '$1 ~ "(" user_id ")" {sum+=$3; count++} END {result=sum/count; printf "%.5f\n", result}' "$u_data")
				paste <(echo "$users") <(echo "average rating") | awk '{print $1, $2}'
			fi
			echo ""
			;;
		9)
			echo "Bye!"
			exit
			;;
	esac
done




