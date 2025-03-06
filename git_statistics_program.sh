#!/bin/bash

# Define Colors
RED='\033[1;31m'
GREEN='\033[1;32m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
MAGENTA='\033[1;35m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Check if GitHub CLI is installed
if ! command -v gh &> /dev/null; then
    echo -e "\n${RED}❌ GitHub CLI (gh) is not installed. Install it using 'sudo apt install gh'.${NC}\n"
    exit 1
fi

# Function to fetch details for a specific repository
fetch_repo_details() {
    local REPO="$1"

    echo -e "\n${BLUE}🔍 Fetching activity for repository: ${CYAN}$REPO${NC}"

    # Fetch branches
    echo -e "\n${MAGENTA}📂 Listing all branches:${NC}"
    gh api "repos/$REPO/branches" --jq '.[] | "🌿 \(.name)"' || echo -e "${RED}❌ Unable to fetch branches.${NC}"

    # Fetch latest commits
    echo -e "\n${MAGENTA}📜 Latest commits on each branch:${NC}"
    for branch in $(gh api "repos/$REPO/branches" --jq '.[].name'); do
        echo -e "\n${CYAN}📌 Branch: ${YELLOW}$branch${NC}"
        gh api "repos/$REPO/commits?sha=$branch" --jq '.[] | "🔹 \(.commit.author.date) - \(.commit.message) by \(.commit.author.name)"' | head -n 5
    done

    # Fetch deleted branches (from merged PRs)
    echo -e "\n${MAGENTA}🚀 Deleted branches (from merged PRs):${NC}"
    gh api "repos/$REPO/pulls?state=closed" --jq '.[] | select(.merged_at != null) | "❌ Deleted branch: 🌿 \(.head.ref) (Merged on: \(.merged_at))"' || echo -e "${RED}❌ No deleted branches found.${NC}"

    # Fetch pull requests
    echo -e "\n${MAGENTA}📬 Pull Requests:${NC}"
    gh pr list --repo "$REPO" --state all --limit 10 --json title,author,createdAt,state --jq '.[] | "📌 \(.state | ascii_upcase): \(.title) by \(.author.login) on \(.createdAt)"'

    # Fetch issues
    echo -e "\n${MAGENTA}🐞 Issues:${NC}"
    gh issue list --repo "$REPO" --state all --limit 10 --json title,author,createdAt,state --jq '.[] | "📌 \(.state | ascii_upcase): \(.title) by \(.author.login) on \(.createdAt)"'

    # Fetch discussions
    echo -e "\n${MAGENTA}💬 Discussions:${NC}"
    gh api "repos/$REPO/discussions" --jq '.[] | "📌 \(.title) by \(.user.login) on \(.created_at)"' 2>/dev/null || echo -e "${RED}❌ No discussions found.${NC}"

    echo -e "\n${GREEN}✅ Done!${NC}\n"
}

# Function to list all repositories for a user and fetch details for each
list_repos() {
    read -p "🔹 Enter GitHub username: " USERNAME
    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    LOGFILE="${USERNAME}_all_repos_data_${TIMESTAMP}.log"

    echo -e "\n${BLUE}📂 Fetching repositories for user: ${CYAN}$USERNAME${NC}" | tee -a "$LOGFILE"

    REPO_LIST=$(gh api "users/$USERNAME/repos" --jq '.[].full_name' 2>/dev/null)

    if [[ -z "$REPO_LIST" ]]; then
        echo -e "${RED}❌ No repositories found or unable to fetch data.${NC}\n" | tee -a "$LOGFILE"
        return
    fi

    for REPO in $REPO_LIST; do
        echo -e "\n${GREEN}========================================${NC}" | tee -a "$LOGFILE"
        echo -e "${YELLOW}📂 Processing repository: ${CYAN}$REPO${NC}" | tee -a "$LOGFILE"
        echo -e "${GREEN}========================================${NC}\n" | tee -a "$LOGFILE"

        fetch_repo_details "$REPO" | tee -a "$LOGFILE"
    done

    echo -e "\n${GREEN}✅ All repositories processed! Log saved to: ${WHITE}$LOGFILE${NC}\n" | tee -a "$LOGFILE"

    read -p "Press enter to return to the main menu: " enter
}

# Function to query a specific repository
query_repo() {
    read -p "🔹 Enter GitHub username: " USERNAME
    read -p "🔹 Enter repository name: " REPO_NAME

    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    LOGFILE="${USERNAME}_${REPO_NAME}_${TIMESTAMP}.log"

    REPO="$USERNAME/$REPO_NAME"

    fetch_repo_details "$REPO" | tee -a $LOGFILE
}

# Function to list log and HTML files, and allow viewing
view_logs() {
    echo -e "\n${MAGENTA}📂 Available files in the current directory:${NC}\n"

    LOG_FILES=$(ls *.log 2>/dev/null)
    HTML_FILES=$(ls *.html 2>/dev/null)

    if [[ -n "$LOG_FILES" ]]; then
        echo -e "${GREEN}✅ Log files found:${NC}\n"
        ls -lha *.log
        echo
    else
        echo -e "${RED}❌ No log files found.${NC}\n"
    fi

    if [[ -n "$HTML_FILES" ]]; then
        echo -e "${GREEN}✅ HTML files found:${NC}\n"
        ls -lha *.html
        echo
    else
        echo -e "${RED}❌ No HTML files found.${NC}\n"
    fi

    echo -e "\n${YELLOW}🔹 Copy and paste a filename from the list above to view it:${NC}\n"
    read -p "📖 File to view: " FILE

    if [[ -f "$FILE" ]]; then
        if [[ "$FILE" == *.log ]]; then
            echo -e "\n${CYAN}📖 Displaying log file: ${WHITE}$FILE${NC}\n"
            cat "$FILE"
        elif [[ "$FILE" == *.html ]]; then
            echo -e "\n${GREEN}🌍 Opening HTML file in browser: ${WHITE}$FILE${NC}\n"
            xdg-open "$FILE" &>/dev/null || echo -e "${RED}❌ Unable to open in browser. Open manually: $FILE${NC}\n"
        else
            echo -e "${RED}❌ Invalid file type. Please select a .log or .html file.${NC}\n"
        fi
    else
        echo -e "${RED}❌ File not found. Please try again.${NC}\n"
    fi

    echo
    read -p "Press enter to return to main menu: " enter
}

# Function to search for a pattern in a log file
search_logs() {
    view_logs
    read -p "🔍 Enter the search pattern: " PATTERN
    grep --color=always -i "$PATTERN" "$LOGFILE" || echo -e "${RED}❌ No matches found.${NC}\n"
    echo
    read -p "Press enter to return to main menu: " enter
}

# Function to delete a specific log file
delete_log() {

    echo
    if ls *.log &>/dev/null; then
      echo "✅ Log files found."
      echo
      ls -lha *.log
      echo
    else
        echo -e "${RED}❌ No log files found to delete${NC}\n"
        read -p "Press enter to return to main menu: " enter
    fi
    read -p "🗑️ Log file to delete: " LOGFILE

    if [[ -f "$LOGFILE" ]]; then
        echo
        echo
        read -p "🔹 ⚠️ WARNING: Are you sure you want to delete $LOGFILE? (y/n): " CONFIRM

        if [[ "$CONFIRM" == "y" ]]; then
            rm -rf "$LOGFILE"
            echo
            echo
            echo -e "${GREEN}✅ $LOGFILE deleted.${NC}\n"
        else
            echo
            echo -e "${RED}❌ Operation cancelled.${NC}\n"
        fi
    else
        echo
        echo -e "${RED}❌ File not found. Please try again.${NC}\n"
    fi
    echo
    read -p "Press enter to return to main menu: " enter
}

# Function to delete all logs
delete_all_logs() {
    echo -e "\n${RED}⚠️ WARNING: This will delete ALL log files in this path:  $PWD.${NC}"
    echo
    if ls *.log &>/dev/null; then
      echo -e "${GREEN}✅ Log files found.${NC}"
      echo
      ls -lha *.log
      echo
      read -p "🔹 ⚠️ WARNING: Are you sure you want to proceed deleting ALL .log files in: $PWD? (y/n): " CONFIRM

      if [[ "$CONFIRM" == "y" ]]; then
          rm -f *.log 2>/dev/null
          echo
          echo -e "${GREEN}✅ All logs deleted.${NC}\n"
      else
          echo
          echo -e "${RED}❌ Operation cancelled.${NC}\n"
      fi
    else
        echo -e "${RED}❌ No log files found to delete${NC}\n"
    fi
    echo
    read -p "Press enter to return to main menu: " enter
}

# Function to generate a futuristic HTML report from a log file
generate_html_report() {
    echo -e "\n${MAGENTA}📂 Available log files:${NC}\n"
    ls -lha *.log 2>/dev/null || { echo -e "${RED}❌ No log files found.${NC}\n"; return; }

    echo -e "\n${YELLOW}🔹 Copy and paste a filename from the list above to generate an HTML report:${NC}\n"
    read -p "📖 Log file to convert: " LOGFILE

    if [[ ! -f "$LOGFILE" ]]; then
        echo -e "${RED}❌ File not found. Please try again.${NC}\n"
        return
    fi

    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    HTMLFILE="${LOGFILE%.log}_report_${TIMESTAMP}.html"

    # Remove ANSI color escape sequences from log file
    CLEANED_LOG=$(sed -E 's/\x1B\[[0-9;]*[mK]//g' "$LOGFILE")

    # Start the HTML structure
    cat <<EOF > "$HTMLFILE"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GitHub Report - $LOGFILE</title>
    <style>
        body {
            font-family: 'Courier New', monospace;
            background-color: #121212;
            color: #00ffaa;
            padding: 20px;
            text-align: center;
        }
        h1 {
            color: #00ffaa;
            text-shadow: 0px 0px 15px #00ffaa;
            font-size: 28px;
            margin-bottom: 5px;
        }
        h2 {
            color: #ddd;
            font-size: 18px;
            margin-top: 0;
            opacity: 0.8;
        }
        .repo-container {
            width: 80%;
            margin: 20px auto;
            background-color: #1e1e1e;
            padding: 15px;
            border-radius: 10px;
            box-shadow: 0px 0px 20px #00ffaa;
            text-align: left;
        }
        .section-title {
            background: linear-gradient(90deg, #00ffaa, #0088cc);
            color: #121212;
            padding: 10px;
            font-weight: bold;
            text-align: center;
            border-radius: 5px;
            font-size: 18px;
            margin-bottom: 10px;
        }
        .content {
            background-color: #000;
            padding: 12px;
            border-radius: 5px;
            margin-top: 10px;
            font-size: 14px;
        }
        .commit { color: #00ffaa; }
        .branch { color: #ffcc00; font-weight: bold; }
        .deleted-branch { color: #ff6666; font-style: italic; }
        .pr { color: #66ff66; }
        .issue { color: #ff9966; }
        .footer {
            margin-top: 20px;
            font-size: 14px;
            opacity: 0.7;
        }
    </style>
</head>
<body>
    <h1>🚀 GitHub Activity Report</h1>
    <h2>File: $LOGFILE</h2>
EOF

    # Variables to track sections
    INSIDE_REPO=false

    # Process log file content and format sections
    while IFS= read -r line; do
        if [[ "$line" == "📂 Processing repository:"* ]]; then
            # Close previous repo container if open
            if [[ "$INSIDE_REPO" == true ]]; then
                echo "</div>" >> "$HTMLFILE"
            fi
            # Start new repo block
            echo '<div class="repo-container">' >> "$HTMLFILE"
            echo "<div class='section-title'>$line</div>" >> "$HTMLFILE"
            INSIDE_REPO=true
        elif [[ "$line" == "📜 Latest commits on each branch:"* ]]; then
            echo '<div class="section-title">📜 Latest Commits</div>' >> "$HTMLFILE"
        elif [[ "$line" == "📌 Branch:"* ]]; then
            echo "<div class='branch'>$line</div>" >> "$HTMLFILE"
        elif [[ "$line" == "🔹 "* ]]; then
            echo "<div class='commit'>$line</div>" >> "$HTMLFILE"
        elif [[ "$line" == "🚀 Deleted branches (from merged PRs):"* ]]; then
            echo '<div class="section-title">🚀 Deleted Branches</div>' >> "$HTMLFILE"
        elif [[ "$line" == "❌ Deleted branch:"* ]]; then
            echo "<div class='deleted-branch'>$line</div>" >> "$HTMLFILE"
        elif [[ "$line" == "📬 Pull Requests:"* ]]; then
            echo '<div class="section-title">📬 Pull Requests</div>' >> "$HTMLFILE"
        elif [[ "$line" == "📌 MERGED:"* ]]; then
            echo "<div class='pr'>$line</div>" >> "$HTMLFILE"
        elif [[ "$line" == "🐞 Issues:"* ]]; then
            echo '<div class="section-title">🐞 Issues</div>' >> "$HTMLFILE"
        elif [[ "$line" == "💬 Discussions:"* ]]; then
            echo '<div class="section-title">💬 Discussions</div>' >> "$HTMLFILE"
        elif [[ "$line" == "✅ Done!"* ]]; then
            echo '<div class="section-title">✅ Report Complete</div>' >> "$HTMLFILE"
        else
            echo "<div class='content'>$line</div>" >> "$HTMLFILE"
        fi
    done <<< "$CLEANED_LOG"

    # Close last repo container if open
    if [[ "$INSIDE_REPO" == true ]]; then
        echo "</div>" >> "$HTMLFILE"
    fi

    # Finish HTML structure
    echo "<div class='footer'>Generated on $(date +"%Y-%m-%d %H:%M:%S")</div></body></html>" >> "$HTMLFILE"

    echo -e "\n${GREEN}✅ HTML report generated: ${WHITE}$HTMLFILE${NC}\n"

    # Ask if user wants to open the file
    read -p "🔹 Open the HTML report in your browser? (y/n): " OPEN_FILE
    if [[ "$OPEN_FILE" == "y" ]]; then
        xdg-open "$HTMLFILE" &>/dev/null || echo -e "${RED}❌ Unable to open in browser. Open manually: $HTMLFILE${NC}\n"
    fi

    read -p "Press enter to return to the main menu: " enter
}

# Menu function
menu() {
    while true; do
        echo -e "\n${CYAN}======================================"
        echo -e "🌟 GitHub Activity Tracker 🌟"
        echo -e "======================================${NC}\n"

        echo -e "${YELLOW}1️⃣ Query all repositories for a user${NC}"
        echo -e "${YELLOW}2️⃣ Query a specific repository${NC}"
        echo -e "${YELLOW}3️⃣ View log files${NC}"
        echo -e "${YELLOW}4️⃣ Search for a pattern in a log file${NC}"
        echo -e "${YELLOW}5️⃣ Delete a specific log file${NC}"
        echo -e "${YELLOW}6️⃣ Delete all log files${NC}"
        echo -e "${YELLOW}7️⃣ Generate a futuristic HTML report from a log file${NC}\n"
        echo -e "${YELLOW}8️⃣ Exit${NC}\n"

        read -p "🔹 Select an option (1-7): " CHOICE
        echo ""

        case $CHOICE in
            1) list_repos ;;
            2) query_repo ;;
            3) view_logs ;;
            4) search_logs ;;
            5) delete_log ;;
            6) delete_all_logs ;;
            7) generate_html_report ;;
            8) echo -e "${GREEN}👋 Exiting...${NC}\n"; exit 0 ;;
            *) echo -e "${RED}❌ Invalid option. Try again.${NC}\n" ;;
        esac
    done
}

# Run the menu
menu
