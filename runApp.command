AppDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
FilesDir="/Users/glebkovalenko/Desktop"
SaveDir="/Users/glebkovalenko/Desktop"
Merge="-m"

cd $AppDir

swift run MdCreator -i $FilesDir -o $SaveDir $Merge

