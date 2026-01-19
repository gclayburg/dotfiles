#!/bin/bash

# Define arrays for color codes
colors=(30 31 32 33 34 35 36 37 90 91 92 93 94 95 96 97)
bg_colors=(40 41 42 43 44 45 46 47 100 101 102 103 104 105 106 107)
color_names=("Black" "Red" "Green" "Yellow" "Blue" "Magenta" "Cyan" "White" \
             "Bright Black" "Bright Red" "Bright Green" "Bright Yellow" \
             "Bright Blue" "Bright Magenta" "Bright Cyan" "Bright White")

# Function to display colors
display_colors() {
    echo "Foreground Colors:"
    for i in "${!colors[@]}"; do
        printf "\e[%sm %-20s \e[0m" "${colors[i]}" "${color_names[i]}"
        [ $(( (i + 1) % 8 )) -eq 0 ] && echo
    done

    echo -e "\nBackground Colors:"
    for i in "${!bg_colors[@]}"; do
        printf "\e[%sm %-20s \e[0m" "${bg_colors[i]}" "${color_names[i]}"
        [ $(( (i + 1) % 8 )) -eq 0 ] && echo
    done

    echo -e "\nForeground and Background Combinations:"
    for fg in "${colors[@]}"; do
        for bg in "${bg_colors[@]}"; do
            printf "\e[%s;%sm FG:%s/BG:%s \e[0m " "$fg" "$bg" "$fg" "$bg"
        done
        echo
    done
}

# Run the display function
display_colors

