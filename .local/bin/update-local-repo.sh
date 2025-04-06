#!/bin/sh  
  
# Ensure 'verbose' is always set  
verbose=0  
  
# Display usage information and exit  
usage() {  
    printf "Usage: %s [options] <directory> <remote_branch>\n" "$0"  
    printf "Options:\n"  
    printf "  -h, --help        Display this help message and exit.\n"  
    printf "  -v, --verbose     Enable verbose output.\n"  
    exit 1  
}  
  
# Parse command-line options and arguments  
args=()  
while [ "$#" -gt 0 ]; do  
    case $1 in  
        -h|--help)  
            usage  
            ;;  
        -v|--verbose)  
            verbose=1  
            ;;  
        *)  
            args+=("$1")  # Collect other arguments  
            ;;  
    esac  
    shift  
done  
  
# Check if correct number of positional arguments is given  
if [ ${#args[@]} -ne 2 ]; then  
    printf "Error: Missing required arguments.\n" >&2  
    usage  
fi  
  
directory=${args[0]}  
remote_branch=${args[1]}  
  
# Function to log messages when verbose mode is active  
log() {  
    if [ "$verbose" -eq 1 ]; then  
        printf "%s\n" "$@"  
    fi  
}  
  
# Save current directory to return later  
current_dir=$(pwd)  
  
# Change to the specified directory  
cd "$directory" || { printf "Error: Unable to access directory %s\n" "$directory"; exit 1; }  
  
# Create a temporary directory and ensure it is removed on script exit  
temp_dir=$(mktemp -d)  
trap 'rm -rf "$temp_dir"' EXIT  
  
# Clone the repository into the temporary directory  
log "Cloning the repository..."  
git clone . "$temp_dir" --recursive  
  
# Change to the temporary directory  
cd "$temp_dir"  
  
# Fetch changes from the specified remote branch without merging  
log "Fetching changes from $remote_branch..."  
git fetch origin "$remote_branch"  
  
# List files that have changed in the remote repository  
log "Listing updated files..."  
updated_files=$(git diff --name-only HEAD..origin/"$remote_branch")  
printf "%s\n" "$updated_files" | tee update-list.txt  
log "Files to be updated:"  
log "$updated_files"  
  
# List locally deleted files, ignoring unversioned files  
log "Listing locally deleted files:"  
deleted_files=$(git ls-files --deleted)  
log "$deleted_files"  
  
# Conditionally checkout files if there are any to update  
if [ -n "$updated_files" ]; then  
    log "Checking out updated files..."  
    printf "%s\n" "$updated_files" | xargs -d '\n' git checkout origin/"$remote_branch" --  
else  
    log "No updated files to checkout."  
fi  
  
# Sync updated files back to the original directory  
log "Syncing files back to the original directory..."  
rsync -av --files-from=update-list.txt ./ "$current_dir"  
  
# Return to the original directory  
cd "$current_dir"  
  
# List files with local changes that might need manual attention  
printf "Files with local changes that need attention:\n"  
git diff --name-only --diff-filter=M  
  
# Script ends here  
exit 0  
