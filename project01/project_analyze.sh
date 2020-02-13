#!/bin/bash
# author:shuren xu
# macid:xus83

fixmeLog(){
    if [ -f "fixme.log" ]
    then
        rm -f fixme.log
    fi
    touch fixme.log
    for i in `find . -type f`
    do
        tail -1 $i > tempRTDCGUIYFHVG
        grep "#FIXME" tempRTDCGUIYFHVG && echo $i >> fixme.log
        rm -f tempRTDCGUIYFHVG
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
    start=`date +%s`
    eval $input
    end=`date +%s`
    let timeCost=end-start
    echo "-----------------------------------------------------------"
    echo "done in $timeCost secs"
}

features

