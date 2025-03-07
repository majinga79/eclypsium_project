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
        echo "This is function feature 6"
        echo
        read -p "Press enter to terminate session: " enter

}

function feature7() {
        echo
        echo "This is function feature 7"
        echo
        read -p "Press enter to terminate session: " enter

}

function feature8() {
        echo
        echo "This is function feature 8"
        echo
        read -p "Press enter to terminate session: " enter

}

function child_feature1() {
        echo
        echo "This is function child feature 1"
        echo
        read -p "Press enter to terminate session: " enter

}

function child_feature2() {
        echo
        echo "This is function child feature 2"
        echo
        read -p "Press enter to terminate session: " enter

}

function child_feature3() {
        echo
        echo "This is function child feature 3"
        echo
        read -p "Press enter to terminate session: " enter

}

function child_feature4() {
        echo
        echo "This is function child feature 4"
        echo
        read -p "Press enter to terminate session: " enter

}

function child_feature5() {
        echo
        echo "This is function child feature 5"
        echo
        read -p "Press enter to terminate session: " enter

}

function child_feature6() {
        echo
        echo "This is function child feature 6"
        echo
        read -p "Press enter to terminate session: " enter

}

function child_feature7() {
        echo
        echo "This is function child feature 7"
        echo
        read -p "Press enter to terminate session: " enter

}

function child_feature8() {
        echo
        echo "This is function child feature 8"
        echo
        read -p "Press enter to terminate session: " enter

}

function child_feature2_1() {
        echo
        echo "This is function child feature 2 - 1"
        echo
        read -p "Press enter to terminate session: " enter

}

function child_feature2_2() {
        echo
        echo "This is function child feature 2 - 2"
        echo
        read -p "Press enter to terminate session: " enter

}

function child_feature2_3() {
        echo
        echo "This is function child feature 2 - 3"
        echo
        read -p "Press enter to terminate session: " enter

}

function child_feature2_4() {
        echo
        echo "This is function child feature 2 - 4"
        echo
        read -p "Press enter to terminate session: " enter

}

function child_feature2_5() {
        echo
        echo "This is function child feature 2 - 5"
        echo
        read -p "Press enter to terminate session: " enter

}

function child_feature2_6() {
        echo
        echo "This is function child feature 2 - 6"
        echo
        read -p "Press enter to terminate session: " enter

}

function child_feature2_7() {
        echo
        echo "This is function child feature 2 - 7"
        echo
        read -p "Press enter to terminate session: " enter

}

function child_feature2_8() {
        echo
        echo "This is function child feature 2 - 8"
        echo
        read -p "Press enter to terminate session: " enter

}

function child_feature2_9() {
        echo
        echo "This is function child feature 2 - 9"
        echo
        read -p "Press enter to terminate session: " enter

}

function child_feature2_10() {
        echo
        echo "This is function child feature 2 - 10"
        echo
        read -p "Press enter to terminate session: " enter

}

function child_feature2_11() {
        echo
        echo "This is function child feature 2 - 11"
        echo
        read -p "Press enter to terminate session: " enter

}

function child_feature2_12() {
        echo
        echo "This is function child feature 2 - 12"
        echo
        read -p "Press enter to terminate session: " enter

}


function child_program() {

  while true; do

    echo
    echo "Child program menu"
    echo
    echo "1 - Child feature 1"
    echo "2 - Child feature 2"
    echo "3 - Child feature 3"
    echo "4 - Child feature 4"
    echo "5 - Child feature 5"
    echo "6 - Child feature 6"
    echo "7 - Child feature 7"
    echo "8 - Child feature 8"
    echo "9 - Main program"
    echo
    read -p "Select feature and press enter: " choice
    case $choice in

      1)
        echo
        child_feature1
        ;;

      2)
        echo
        child_feature2
        ;;

      3)
        echo
        child_feature3
        ;;

      4)
        echo
        child_feature4
        ;;

      5)
        echo
        child_feature5
        ;;

      6)
        echo
        child_feature6
        ;;

      7)
        echo
        child_feature7
        ;;

      8)
        echo
        child_feature8
        ;;

      9)
        echo
        main_program
        ;;

      *)
        echo
        read -p "Invalid option provided. Press enter to continue to main menu: " enter
        ;;

		  esac
	done

}

function child_program2() {

  while true; do

    echo
    echo "Child program 2 menu"
    echo
    echo "1 - Child feature 2 - 1"
    echo "2 - Child feature 2 - 2"
    echo "3 - Child feature 2 - 3"
    echo "4 - Child feature 2 - 4"
    echo "5 - Child feature 2 - 5"
    echo "6 - Child feature 2 - 6"
    echo "7 - Child feature 2 - 7"
    echo "8 - Child feature 2 - 8"
    echo "9 - Child feature 2 - 9"
    echo "10 - Child feature 2 - 10"
    echo "11 - Child feature 2 - 11"
    echo "12 - Child feature 2 - 12"
    echo "13 - Main program"
    echo
    read -p "Select feature and press enter: " choice
    case $choice in

      1)
        echo
        child_feature2_1
        ;;

      2)
        echo
        child_feature2_2
        ;;

      3)
        echo
        child_feature2_3
        ;;

      4)
        echo
        child_feature2_4
        ;;

      5)
        echo
        child_feature2_5
        ;;

      6)
        echo
        child_feature2_6
        ;;

      7)
        echo
        child_feature2_7
        ;;

      8)
        echo
        child_feature2_8
        ;;

      9)
        echo
        child_feature2_9
        ;;

      10)
        echo
        child_feature2_10
        ;;

      11)
        echo
        child_feature2_11
        ;;

      12)
        echo
        child_feature2_12
        ;;

      13)
        echo
        main_program
        ;;

      *)
        echo
        read -p "Invalid option provided. Press enter to continue to main menu: " enter
        ;;

		  esac
	done

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
    echo "8 - Feature 8"
    echo "9 - Child program"
    echo "10 - Child program 2"
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

      4)
        echo
        feature4
        ;;

      5)
        echo
        feature5
        ;;

      6)
        echo
        feature6
        ;;

      7)
        echo
        feature7
        ;;
      8)
        echo
        feature8
        ;;

      9)
        echo
        child_program
        ;;

      10)
        echo
        child_program2
        ;;
      *)
        echo
        read -p "Invalid option provided. Press enter to continue to main menu: " enter
        ;;

		  esac
	done


}
main_program
