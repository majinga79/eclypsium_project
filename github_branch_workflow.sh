#!/bin/bash

# Function to delete untracked branches
delete_untracked_branches() {
    echo
    repo_path=${repo_path:-$PWD}  # Default to current directory if empty
    repo_path=$(eval echo "$repo_path")  # Expand ~ (home directory)

    # Validate that the directory exists
    if [[ ! -d "$repo_path" ]]; then
        echo
        echo "❌ Error: Directory '$repo_path' does not exist."
        return 1
    fi

    # Validate that it's a Git repository
    if [[ ! -d "$repo_path/.git" ]]; then
        echo
        echo "❌ Error: '$repo_path' is not a valid Git repository."
        return 1
    fi

    # Move into the repository directory
    cd "$repo_path" || { echo "❌ Error: Failed to enter directory '$repo_path'"; return 1; }

    # Fetch latest remote branches
    echo
    echo "🔄 Fetching the latest remote branches..."
    git fetch --prune

    # List all local branches
    echo
    echo "🔎 Local branches in this repository:"
    git branch
    echo

    # List all remote branches
    echo
    echo "🔎 Remote branches in this repository:"
    git branch -r
    echo

    # Get current branch name
    current_branch=$(git rev-parse --abbrev-ref HEAD)

    # Find local branches that no longer have a remote
    echo "🔎 Checking for local branches without a remote counterpart..."
    untracked_branches=($(git branch --format "%(refname:short)" | while read -r branch; do
        if ! git ls-remote --exit-code --heads origin "$branch" > /dev/null 2>&1; then
            echo "$branch"
        fi
    done))

    # If no untracked branches exist, exit
    if [[ ${#untracked_branches[@]} -eq 0 ]]; then
        echo
        echo "✅ No local branches found without a remote counterpart."
        return 0
    fi

    # Prompt the user for deletion
    echo
    echo "⚠️ The following local branches have no remote counterpart:"
    for branch in "${untracked_branches[@]}"; do
        echo
        read -rp "Delete local branch '$branch'? (y/n): " confirm
        if [[ "$confirm" == "y" ]]; then
            if [[ "$branch" == "$current_branch" ]]; then
                echo
                echo "⚠️ Cannot delete the currently checked-out branch '$branch'. Switching to 'master' first..."
                git checkout master || git checkout main
            fi
            git branch -D "$branch"
            echo
            echo "✅ Deleted local branch '$branch'."
        else
            echo
            echo "❌ Skipping deletion of '$branch'."
        fi
    done
    echo
    echo "🎉 Cleanup complete!"
}

# Main script logic
# Step 1: Validate user authentication
ssh -T git@github.com

# Step 2: Prompt for branch name
echo
read -p "Enter the new branch name: " branch_name
git branch "$branch_name"
echo
git checkout "$branch_name"
echo
read -p "Start working on your changes. Press Enter when done: " enter

# Step 3: Stage changes
echo
read -p "Do you want to stage all files? (y/n): " stage_all
if [[ "$stage_all" == "y" ]]; then
    git add .
else
    echo "Enter the files to stage (space-separated): "
    read files_to_stage
    git add $files_to_stage
fi

# Step 4: Commit changes
echo
read -p "Enter commit message:" commit_msg
git commit -m "$commit_msg"
echo
# Step 5: Push changes
git push --set-upstream origin "$branch_name"
echo
# Step 6: Extract GitHub username
logged_user=$(grep -oP '(?<=user: ).*' $HOME/snap/gh/502/.config/gh/hosts.yml)

# Step 7: Extract repository name
repo_name=$(basename -s .git $(git config --get remote.origin.url))

# Step 8: Construct PR URL
pr_url="https://github.com/$logged_user/$repo_name/pull/new/$branch_name"

echo "Opening PR in Chrome..."
echo
google-chrome --profile-directory=Default "$pr_url"

read -p "Wait for approval or merge the PR if authorized. Press Enter when done: " enter

# Step 9: Delete remote branch
git push origin --delete "$branch_name"
echo
delete_untracked_branches

git pull

echo
# Step 10: Provide report
echo "\n🔥 Summary of actions taken:\n"
echo "✔️ Created and checked out branch: $branch_name"
echo "✔️ Staged files"
echo "✔️ Committed changes with message: '$commit_msg'"
echo "✔️ Pushed branch to remote"
echo "✔️ Opened PR in Chrome: $pr_url"
echo "✔️ Deleted remote branch"
echo "✔️ Cleaned up local untracked branches"
echo "✔️ Pulled latest changes"
echo "🎉 All steps completed successfully!"
