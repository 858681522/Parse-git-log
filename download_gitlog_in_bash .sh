# open gitHub project in bash 

# download logs 
echo commit,author_name,time_sec,message,files_changed,lines_inserted,lines_deleted>../logfiles.csv; # specify save path 
git log  --oneline --pretty="_Z_Z_Z_%h_Y_Y_\"%an\"_Y_Y_%at_Y_Y_\"%<(79,trunc)%f\"_Y_Y__X_X_"  --stat    \
    | grep -v \| \
    | sed -E 's/@//g' \
    | sed -E 's/_Z_Z_Z_/@/g' \
    |  tr "\n" " "   \
    |  tr "@" "\n" |sed -E 's/,//g'  \
    | sed -E 's/_Y_Y_/, /g' \
    | sed -E 's/(changed [0-9].*\+\))/,\1,/'  \
    | sed -E 's/(changed [0-9]* deleti.*-\)) /,,\1/' \
    | sed -E 's/insertion.*\+\)//g' \
    | sed -E 's/deletion.*\-\)//g' \
    | sed -E 's/,changed/,/' \
    | sed -E 's/files? ,/,/g'  \
    | sed -E 's/_X_X_ $/,,/g'  \
    | sed -E 's/_X_X_//g'>>../turn_log_into_dataset/data/${GROUP_PROJECT}/${PROJECT_NAME}_logfiles.csv 


# download files name in each commit
function getcommit { \
    git show --pretty="format:"  --name-only $1 | \
    perl -pe's/^\n//g;' | \
    sed 's/\(.*\)/"\1"/g' | \
    perl -0pe 's/\n(?!\Z)/,\n/g'; \
}

export -f getcommit

git log --pretty=format:'{%n  "commit": "%h",%n  "files": [ COMMIT_HASH_%H  ]%n},' | \
perl -pe 'BEGIN{print "["}; END{print "]\n"}' | \
perl -pe 's/},]/}]/;s/COMMIT_HASH_(\w+)/`echo"";getcommit $1`/e' &> ../files.txt # specify save path 
