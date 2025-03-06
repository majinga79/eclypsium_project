#!/bin/bash

function feature1() {
	echo
        echo "This is function feature 1"
        echo
        read -p "Press enter to terminate session: " enter
	
}

function feature2() {
        echo
        echo "This is function feature 2"
        echo
        read -p "Press enter to terminate session: " enter

}

function feature3() {
        echo
        echo "This is function feature 3"
        echo
        read -p "Press enter to terminate session: " enter

}

function feature4() {
        echo
        echo "This is function feature 4"
        echo
        read -p "Press enter to terminate session: " enter

}

function feature5() {
        echo
        echo "This is function feature 5"
        echo
        read -p "Press enter to terminate session: " enter

}

function feature6() {
        echo
        echo "This is function feature 5"
        echo
        read -p "Press enter to terminate session: " enter

}

function main_program() {

	while true; do
		echo
                echo "Main program menu"
                echo
                echo "1 - Feature 1"
                echo "2 - Feature 2"
		            echo "3 - Feature 3"
		            echo "4 - Feature 4"
		            echo "5 - Feature 5"
		            echo "6 - Feature 6"
                echo
                read -p "Select feature and press enter: " choice
		case $choice in
                    1)
		      echo
		      feature1
                      ;;

		    2)
                      echo
                      feature2
		      ;;

                    3)
		      echo
                      feature3
                      ;;

		    *)
		      echo
                      read -p "Invalid option provided. Press enter to continue to main menu: " enter

		esac
	done


}
main_program
