# Parse-git-log-into-dataset
Aim: parse git log into structured datasets and json files.

## Steps:

For example, we are interested in GitHub project: "talon-twitter-holo". https://github.com/klinker24/talon-twitter-holo
* 1. open gitHub project in bash ,run "download_gitlog_in_bash".
```
echo commit,author_name,time_sec,message,files_changed,lines_inserted,lines_deleted>../talon-twitter-holo_logfiles.csv; # specify save path 
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
    | sed -E 's/_X_X_//g'>>../talon-twitter-holo_logfiles.csv  # specify save path 

```

### Output : .csv file
```
commit,     author_name,    time_sec,     message,                                                               files_changed,lines_inserted,lines_deleted
f1ca916, "Luke Klinker", 1530723223, "fix-login-issue                                                             ",    3 ,11 , 4  
da050cb, "Luke Klinker", 1528992540, "Add-deprecation-notice-in-favor-of-material-design-version                  ",    1 , 6 , 
e7b9dc7, "Luke Klinker", 1520880295, "update-strings                                                              ",    7 , 425 , 323  
2e7158b, "Luke Klinker", 1518613587, "update-translations                                                         ",    6 , 133 , 101  
9e5ff49, "Luke Klinker", 1518374371, "Merge-pull-request-44-from-rgarza-compat_with_oreo                          ",    ,,
2616ec3, "Rene de la Garza", 1518372585, "added-create-channel-for-service-notifications-for-8.1-compatibility    ",    15 , 77 , 36  
02abd1d, "Luke Klinker", 1516914002, "Fix-the-scheduled-tweet-activity-to-close-43                                ",    2 , 108 , 93  
c1e7855, "Luke Klinker", 1513779855, "New-Save-tweets-for-later                                                   ",    16 , 537 , 16  
7398240, "Luke Klinker", 1510253736, "stop-forcing-the-orientation                                                ",    8 ,, 46 
567352f, "Luke Klinker", 1510177580, "apply-the-longer-280-character-tweets-to-the-split-tweet-functionality      ",    1 , 2 , 2  
9c91b76, "Luke Klinker", 1510169009, "fix-a-force-close                                                           ",    1 ,, 7 
c087bd0, "Luke Klinker", 1510150517, "fix-build                                                                   ",    2 , 1 , 10  
f70300d, "Luke Klinker", 1510150280, "update-some-dependencies-and-version-number                                 ",    2 , 9 , 9  

...
```
* 2. download files name in each commit
```
function getcommit { \
    git show --pretty="format:"  --name-only $1 | \
    perl -pe's/^\n//g;' | \
    sed 's/\(.*\)/"\1"/g' | \
    perl -0pe 's/\n(?!\Z)/,\n/g'; \
}

export -f getcommit

git log --pretty=format:'{%n  "commit": "%h",%n  "files": [ COMMIT_HASH_%H  ]%n},' | \
perl -pe 'BEGIN{print "["}; END{print "]\n"}' | \
perl -pe 's/},]/}]/;s/COMMIT_HASH_(\w+)/`echo"";getcommit $1`/e' &> ../talon-twitter-holo_files.txt # specify save path 

```
### Output: json format .txt file
```
[{
  "commit": "f1ca916",
  "files": [ 
"app/src/main/java/com/klinker/android/twitter/activities/setup/LoginActivity.java",
"app/src/main/res/xml/changelog.xml",
"gradle.properties"
  ]
},
{
  "commit": "da050cb",
  "files": [ 
"README.md"
  ]
},
{
  "commit": "e7b9dc7",
  "files": [ 
"app/src/main/res/values-ar/strings.xml",
"app/src/main/res/values-da/strings.xml",
"app/src/main/res/values-de/strings.xml",
"app/src/main/res/values-hu/strings.xml",
"app/src/main/res/values-it/strings.xml",
"app/src/main/res/values-nb/strings.xml",
"app/src/main/res/values-tr/strings.xml"
  ]
},
{
  "commit": "2e7158b",
  "files": [ 
"app/src/main/res/values-da/strings.xml",
"app/src/main/res/values-de/strings.xml",
"app/src/main/res/values-es/strings.xml",
"app/src/main/res/values-hu/strings.xml",
"app/src/main/res/values-nb/strings.xml",
"app/src/main/res/values-pt-rBR/strings.xml"
  ]
},
{
  "commit": "9e5ff49",
  "files": [ 
  ]
},
{
  "commit": "2616ec3",
  "files": [ 
"app/src/main/java/com/klinker/android/twitter/activities/compose/Compose.java",
"app/src/main/java/com/klinker/android/twitter/activities/photo_viewer/PhotoFragment.java",
"app/src/main/java/com/klinker/android/twitter/activities/photo_viewer/PhotoViewerActivity.java",
"app/src/main/java/com/klinker/android/twitter/activities/tweet_viewer/TweetPager.java",
"app/src/main/java/com/klinker/android/twitter/activities/tweet_viewer/fragments/VideoFragment.java",
"app/src/main/java/com/klinker/android/twitter/data/App.java",
"app/src/main/java/com/klinker/android/twitter/services/SendQueue.java",
"app/src/main/java/com/klinker/android/twitter/services/SendScheduledTweet.java",
"app/src/main/java/com/klinker/android/twitter/services/SendTweet.java",
"app/src/main/java/com/klinker/android/twitter/services/TalonPullNotificationService.java",
"app/src/main/java/com/klinker/android/twitter/services/TrimDataService.java",
"app/src/main/java/com/klinker/android/twitter/services/WidgetRefreshService.java",
"app/src/main/java/com/klinker/android/twitter/settings/AppSettings.java",
"app/src/main/java/com/klinker/android/twitter/utils/ActivityUtils.java",
"app/src/main/java/com/klinker/android/twitter/utils/NotificationUtils.java"
  ]
},

....

```
* 3. run "concatenate_two_files_into_one_dataset.ipynb" to concatenate two files. 

