#!/bin/bash
# author:shuren xu
# macid:xus83

fixmeLog(){
    if [ -f "fixme.log" ]
    then
        rm -f fixme.log
    fi
    for i in `find ./project01 -type f`
    do
        echo $i
        if [ -n `grep "#FIXME" $i | tail -1` ]
        then
            echo $i >> project01/fixme.log
        fi
    done
}

features(){
    echo "please enter the feature you need as follow"
    echo "'fixmeLog' "
    echo "please be careful about the uppercases"
    read input
    echo "the feature will be activated is $input"
    echo "anytime to run a feature just enter the name of the feature"
    echo "-----------------------------------------------------------"
    echo "for help enter 'features'"
    echo "-----------------------------------------------------------"
    echo "running"
    echo "-----------------------------------------------------------"
    eval $input
    echo "-----------------------------------------------------------"
    echo "done"
}

features




