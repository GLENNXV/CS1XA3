#!/bin/bash
# author:shuren xu
# macid:xus83

# detect temporary files and delete them if there is any
scriptInit(){
    if [ -e ./CS1XA3/Project01/scriptemp ]
    then
        rm -f ./CS1XA3/Project01/scriptemp
    fi

    if [ -e ./CS1XA3/Project01/scriptemp2 ]
    then
        rm -f ./CS1XA3/Project01/scriptemp2
    fi

    if [ -e ./CS1XA3/Project01/gitLog.log ]
    then
        rm -f ./CS1XA3/Project01/gitlog.log
    fi
}

# feature FIXME Log
fixmeLog(){
    if [ -f ./CS1XA3/Project01/fixme.log ]
    then
        rm -f ./CS1XA3/Project01/fixme.log
    fi
    touch ./CS1XA3/Project01/fixme.log
    for i in `find ./CS1XA3/Project01 -type f`
    do
        tail -1 $i > ./CS1XA3/Project01/scriptemp
        grep "#FIXME" ./CS1XA3/Project01/scriptemp && echo $i >> ./CS1XA3/Project01/fixme.log
        rm -f ./CS1XA3/Project01/scriptemp
    done
}

# feature Checkout Latest Merge
chkMerge(){
    cd ./CS1XA3
    git log > ./Project01/gitLog.log
    grep -C 4 "merge" ./Project01/gitLog.log > ./Project01/scriptemp
    commitID=`head -n 1 ./Project01/scriptemp`
    rm -f ./Project01/gitlog.log
    rm -f ./Project01/scriptemp
    cd ..
    if [ -z $commitId ]
    then
        echo "no git commit matches 'merge'"
    else
        commitID=${commitID:7:47}
        git checkout $commitID
    fi
}

# feature File Size List
fileSize(){
    for i in `find ./CS1XA3/Project01 -type f`
    do
        du -h $i >> ./CS1XA3/Project01/scriptemp
    done
    sort -h ./CS1XA3/Project01/scriptemp >> ./CS1XA3/Project01/scriptemp2
    cat ./CS1XA3/Project01/scriptemp2
    rm -f ./CS1XA3/Project01/scriptemp
    rm -f ./CS1XA3/Project01/scriptemp2
}

#feature Switch to Executable
toExe(){
    read -p "please enter change or restore: " input
    if [ $input = "change" ]
    then
        if [ -e ./CS1XA3/Project01/permissions.log ]
        then
            rm -f ./CS1XA3/Project01/permissions.log
        fi
        touch ./CS1XA3/Project01/permissions.log
        for i in `find ./CS1XA3/Project01 -type f`
        do
            file=`ls -l $i`
            pms="${file:0:10} $i"
            echo $pms >> ./CS1XA3/Project01/permissions.log
            if [ "${pms:2:1}" = "w" ]
            then
                chmod u+x $i
            fi
            if [ "${pms:5:1}" = "w" ]
            then
                chmod g+x $i
            fi
            if [ "${pms:8:1}" = "w" ]
            then
                chmod o+x $i
            fi
        done
    elif [ $input = "restore" ]
    then
        if [ -e ./CS1XA3/Project01/permissions.log ]
        then
            while IFS= read -r i
            do
                chmod ${i:0:10} ${i:12}
            done < ./CS1XA3/Project01/permissions.log
        else
            echo "file log doesn't exist, cannot restore files before ther're changed"
        fi
    else
        echo "entered script soesn't match change or restore"
    fi
}

# the instrctions shows up when none argument is given
features(){
    echo "please enter the feature you need as follow"
    echo "'fixmeLog'  'chkMerge'  'fileSize'"
    echo "please be careful of the uppercases"
    echo "to exit enter 'exit'"
    read -p "feature name: " input
    if [ $input = "exit" ]
    then
        eval $input
    fi
    echo "the feature will be activated is $input"
    echo "-----------------------------------------------------------"
    start=`date +%s`
    eval $input
    end=`date +%s`
    echo "-----------------------------------------------------------"
    let timeCost=end-start
    if [ $timeCost == 0 ]
    then
        echo "done in less than 1 sec"
    else
        echo "done in $timeCost secs"
    fi
    echo "-----------------------------------------------------------"
}

# detect temporary files and delete them if there is any
scriptInit

# main function logic
# script mode for no infinite loops and no timer
# UI mode is on the contrary
if [ $# -ge 1 ]
then
    eval $1
    echo "-----------------------------------------------------------"
    echo "done"
else
    while true
    do
        features
    done
fi

