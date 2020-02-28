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
    if [ -z "$commitId" ]
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
    if [ "$input" = "change" ]
    then
        if [ -e ./CS1XA3/Project01/permissions.log ]
        then
            rm -f ./CS1XA3/Project01/permissions.log
        fi
        touch ./CS1XA3/Project01/permissions.log
        for i in `find ./CS1XA3/Project01 -type f`
        do
            if [ ${i##*.} = "sh" ]
            then
                usr=""
                file=`ls -l $i`
                pms="${file:0:10}" "$i"
                if [ "${file:2:1}" = "w" ]
                then
                    chmod u+x $i
                    usr="$usr""u"
                fi
                if [ "${file:5:1}" = "w" ]
                then
                    chmod g+x $i
                    usr="$usr""g"
                fi
                if [ "${file:8:1}" = "w" ]
                then
                    chmod o+x $i
                    usr="$usr""o"
                fi
                pms="$pms" "$usr"
                echo "$pms" >> ./CS1XA3/Project01/permissions.log
            fi
        done
    elif [ "$input" = "restore" ]
    then
        if [ -e ./CS1XA3/Project01/permissions.log ]
        then
            while IFS= read -r i
            do
                pms=()
                for j in $i
                do
                    pms=("${pms[@]}" "$j")
                done
                chmod "${pms[2]}-x" "${pms[1]}"
            done < ./CS1XA3/Project01/permissions.log
        else
            echo "permissions.log doesn't exist, cannot restore files"
        fi
    else
        echo "entered script soesn't match change or restore"
    fi
}

bkup(){
    read -p "please enter backup or restore: " input
    if [ "$input" = "backup" ]
    then
        if [ -e ./CS1XA3/Project01/backup ]
        then
            rm -rf ./CS1XA3/Project01/backup
        fi
        mkdir ./CS1XA3/Project01/backup
        touch ./CS1XA3/Project01/backup/restore.log
        for i in `find ./CS1XA3/Project01 -type f`
        do
            if [ "${i##*.}" = tmp ]
            then
                file="${i##*/}"" ""${i%/*}" #(name dir)
                echo $file >> ./CS1XA3/Project01/backup/restore.log
                cp $i ./CS1XA3/Project01/backup
                rm -f $i
            fi
        done
    elif [ "$input" = "restore" ]
    then
        if [ -e ./CS1XA3/Project01/backup/restore.log ]
        then
            while IFS= read -r i
            do
                file=()
                for j in $i
                do
                    file=("${file[@]}" "$j")
                done
                if [ -e "./CS1XA3/Project01/backup/${file[0]}" ]
                then
                    cp "./CS1XA3/Project01/backup/${file[0]}" "${file[1]}"
                else
                    echo "restore failed due to backup files does not exist"
                fi
            done < ./CS1XA3/Project01/backup/restore.log
        else
            echo "restore.log doesn't exist, cannot restore files"
        fi
    else
        echo "entered script soesn't match backup or restore"
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

