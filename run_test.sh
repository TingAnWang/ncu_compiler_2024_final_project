#!/bin/bash

TEST_DIR="test"
PROGRAM_NAME=""
PASSED=0
FAILED=0

# Color definitions
COLOR_BRIGHT_BLUE="\033[36m"
COLOR_BLUE="\033[34m"
COLOR_RESET="\033[0m"
COLOR_GREEN="\033[32m"
COLOR_RED="\033[31m"
COLOR_YELLOW="\033[33m"
COLOR_PURPLE="\033[35m"

# Clear screen
clear

# Display header
echo -e "${COLOR_BRIGHT_BLUE}+------------------------------------------------+${COLOR_RESET}"
echo -e "${COLOR_BRIGHT_BLUE}|        NCU Compilers Homework, 2023 Fall       |${COLOR_RESET}"
echo -e "${COLOR_BRIGHT_BLUE}|                   Test Script                  |${COLOR_RESET}"
echo -e "${COLOR_BRIGHT_BLUE}+------------------------------------------------+${COLOR_RESET}"

# Run tests
for test_file in $TEST_DIR/*_hidden.lsp; do
    test_name=$(basename "$test_file" .lsp)  # Remove the .lsp extension

    # Read the expected output
    if [ -f "$TEST_DIR/$test_name.out" ]; then
        expected_output=$(cat "$TEST_DIR/$test_name.out")
    else
        expected_output="(Missing .out file)"
    fi

    # Capture the actual output
    actual_output=$(python3 main.py < "$test_file")

    # Display test name
    echo -e "${COLOR_BRIGHT_BLUE}Test: $test_name${COLOR_RESET}"

    if [ "$expected_output" == "$actual_output" ]; then
        echo -e "${COLOR_GREEN}Result: PASS${COLOR_RESET}"
        echo -e "${COLOR_RED}Actual Output:${COLOR_RESET}"
        echo -e "${COLOR_RED}$(echo "$actual_output")${COLOR_RESET}"
        ((PASSED++))
    else
        echo -e "${COLOR_RED}Result: FAIL${COLOR_RESET}"
        echo -e "${COLOR_BLUE}Input:${COLOR_RESET}"
        echo -e "${COLOR_BLUE}$(cat "$test_file")${COLOR_RESET}"
        echo -e "${COLOR_YELLOW}Expected Output:${COLOR_RESET}"
        echo -e "${COLOR_YELLOW}$(echo "$expected_output")${COLOR_RESET}"
        echo -e "${COLOR_RED}Actual Output:${COLOR_RESET}"
        echo -e "${COLOR_RED}$(echo "$actual_output")${COLOR_RESET}"

        # Optionally display differences using `diff` if available
        if command -v diff &> /dev/null; then
            echo -e "${COLOR_PURPLE}Differences:${COLOR_RESET}"
            diff <(echo "$expected_output") <(echo "$actual_output")
        fi

        ((FAILED++))
    fi

    echo -e "${COLOR_PURPLE}-----------------------------------${COLOR_RESET}"
done

# Summary
echo -e "${COLOR_YELLOW}Tests completed.${COLOR_RESET} ${COLOR_GREEN}Passed: $PASSED${COLOR_RESET}, ${COLOR_RED}Failed: $FAILED${COLOR_RESET}"
