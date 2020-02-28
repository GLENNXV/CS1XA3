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

#feature Backup and Restore
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

#feature File Filter and Sort
filter(){
    read -p "please select to show files only (enter 1 or leave blank) or files and directories (enter 2) : " mode
    if [ "$mode" = "1" -o "$mode" = "" ]
    then
        files=`find ./CS1XA3/Project01 -type f | sort`
    elif [ "$mode" = "2" ]
    then
        files=`ls ./CS1XA3/Project01 | sort`
        for i in $files
        do
            echo "./CS1XA3/Project01/$i" >> ./CS1XA3/Project01/scriptemp
        done
        files=`cat ./CS1XA3/Project01/scriptemp`
        echo $files
        rm -f ./CS1XA3/Project01/scriptemp
    fi
    if [ "$files" = "" ]
    then
        echo "there are no files in the directory"
        return 0
    fi
    read -p "filter files by (extensions, permissions, time, empty, hidden): " input
        if [ "$input" = "extensions" ]
        then
            read -p "show files that have the same extensions as: " ext
            if [ "$ext" = "" ]
            then
                for i in $files
                do
                    nm=${i##*/}
                    if [ "${nm##*.}" = "$nm" ]
                    then
                        echo $i
                    fi
                done
            else
                for i in $files
                do
                    if [ "${i##*.}" = "$ext" ]
                    then
                        echo $i
                    fi
                done
            fi
        elif [ "$input" = "permissions" ]
        then
            read -p "show files that have the same permissions (10 chars) as: " pms
            for i in $files
            do
                fileP=`ls -l $i`
                if [ "${fileP:0:10}" = "$pms" ]
                then
                    echo $i
                fi
            done
        elif [ "$input" = "time" ]
        then
            read -p "show files that are modified (earlier or later) : " compare
            if [ "$compare" = "earlier" -o "$compare" = "later" ]
            then
                echo ""
            else
                echo "invalid parameter"
                return 0
            fi
            read -p "than (format: YYYY-MM-DD hh:mm:ss): " inTime
            coTime=`date -d "$inTime" +%s`
            for i in $files
            do
                modTime=`stat -c %Y $i`
                if [ "$compare" = "earlier" ]
                then
                    if [ "$modTime" -le "$coTime" ]
                    then
                        echo $i
                    fi
                elif [ "$compare" = "later" ]
                then
                    if [ "$modTime" -ge "$coTime" ]
                    then
                        echo $i
                    fi
                fi
            done
        elif [ "$input" = "empty" ]
        then
            echo "files that are empty:"
            for i in $files
            do
                if [ ! -s $i ]
                then
                    echo $i
                fi
            done
        elif [ "$input" = "hidden" ]
        then
            echo "files that are hidden: "
            files=`ls -a ./CS1XA3/Project01 | sort`
            for i in $files
            do
                if [ "${i:0:1}" = "." ]
                then
                    echo "./CS1XA3/Project01/$i"
                fi
            done
        else
            echo "invalid input"
        fi
}

#
encrypt(){
    read -p "please select to encrypt or decrypt: " input
    if [ "$input" = "encrypt" ]
    then
        if [ -e ./CS1XA3/Project01/extEncrpt.log ]
        then
            rm -f ./CS1XA3/Project01/extEncrpt.log
        fi
        touch ./CS1XA3/Project01/extEncrpt.log
        read -p "please enter the ralative path of the file being encrypted: " file
        fileDir=${file%/*}
        fullName="${file##*/}"
        ext="${fullName##*.}"
        pureName=${fullName%.*}
        newName="$fileDir""/""$pureName"".somefile"
        mv "$file" "$newName"
        echo "$newName" "$ext" >> ./CS1XA3/Project01/extEncrpt.log
    elif [ "$input" = "decrypt" ]
    then
        if [ -e "./CS1XA3/Project01/extEncrpt.log" ]
        then
            while IFS= read -r i
                do
                    arr=()
                    for j in $i
                    do
                        arr=("${arr[@]}" "$j")
                    done
                    file=${arr[0]}
                    fileDir=${file%/*}
                    fullName="${file##*/}"
                    ext="${fullName##*.}"
                    pureName=${fullName%.*}
                    newName="$fileDir""/""$pureName"".""${arr[1]}"
                    mv "$file" "$newName"
                done < ./CS1XA3/Project01/extEncrpt.log
        else
            echo "log file does not exist, cannot decrypt"
        fi
    else
        echo "invalid input"
    fi
}

# the instrctions shows up when no argument is given
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

# main function
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
