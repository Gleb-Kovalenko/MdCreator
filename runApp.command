AppDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
FilesDir="/Users/glebkovalenko/Desktop"
SaveDir="/Users/glebkovalenko/Desktop"
GitRep="https://github.com/Gleb-Kovalenko/Test"
Merge="-m"
PushToGit="true"

cd $AppDir

if [ 'true' = "$PushToGit" ]; then

    echo "Pushing README.md file to git..."
    CurrentBranch="$( git branch --show-current)"
    git add README.md
    git commit -m "Update README file"
    git push -u $GitRep main

elif [ 'false' = "$PushToGit" ]; then

    echo "README.md won't push to git"

else

    echo "Error with PushToGit variable: some other value (not true or false)"

fi