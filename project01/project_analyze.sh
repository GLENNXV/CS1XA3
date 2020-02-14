#!/bin/bash
# author:shuren xu
# macid:xus83

# detect temporary files and delete them if there is any
scriptInit(){
    if [ -e scriptemp ]
    then
        rm -f scriptemp
    fi

    if [ -e scriptemp2 ]
    then
        rm -f scriptemp2
    fi

    if [ -e gitLog.log ]
    then
        rm -f gitlog.log
    fi
}


fixmeLog(){
    if [ -f "fixme.log" ]
    then
        rm -f fixme.log
    fi
    touch fixme.log
    for i in `find . -type f`
    do
        tail -1 $i > scriptemp
        grep "#FIXME" scriptemp && echo $i >> fixme.log
        rm -f scriptemp
    done
}

chkMerge(){
    git log > gitLog.log
    grep -C 4 "merge" gitLog.log > scriptemp
    commitID=`head -n 1 scriptemp`
    rm -f gitlog.log
    rm -f scriptemp
    lenID=${#commitID}
    let lenID-=7
    commitID=${commitID:7:$lenID}
    git checkout $commitID
}

fileSize(){
    for i in `find ./ -type f`
    do
        du -h $i >> scriptemp
    done
    sort -h scriptemp >> scriptemp2
    cat scriptemp2
    rm -f scriptemp
    rm -f scriptemp2
}

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

scriptInit

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

