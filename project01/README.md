# CS 1XA3 Project01 - <xus83@mcmaster.ca>
## Usage
Execute this script from project root with:
```
chmod +x CS1XA3/Project01/project_analyze.sh
./CS1XA3/Project01/project_analyze [arg1](optional)
```
**With or without possible arguments**

arg1: the corresponding name for the feature you want to activate refers to below execution guide\
i.e. 'fixmeLog' for 'FIXME Log'

Please be careful of the uppercases

More given argument would be ignored

**If none arguments is given,there would be instructions like below when executing**

*If some are given then there won't be any instruction and it would automatically exit after execution.*\
*using the instruction is recommended since there is an infinite loop to cycle it, and there is a timer for each cycle.*

![instruction example](https://i.loli.net/2020/02/14/4TD6rVJeyWcO7fZ.png)

**Notice: Since this script relies on creating temporary files, not having the permission to create files in current directory would results in unpredictble bugs. So please make sure you have the write permissionin in current directory.** 
##  FIXME Log
Description: 
* Find every file in your repo that has the word #FIXME in the last line
* Put the list of these file names in CS1XA3/Project01/fixme.log with each file separated by a
newline
* Create the file CS1XA3/Project01/fixme.log if it doesn’t exist, overwrite it if it does

Execution:
* execute this feature by entering 'fixmeLog' as argument1.
* Or follow the instructions instead

Reference: some code was taken from [Bash scripting cheatsheet](https://devhints.io/bash)
## Checkout Latest Merge
Description: 
* Find the most recent commit with the word merge (case insensitive) in the commit message
* Automatically checkout that commit (so that you’re in a detached head state)

Execution: 
* execute this feature by entering 'chkMerge' as argument1. 
* Or follow the instructions instead

Reference: some code was taken from [Git Doc](https://git-scm.com/docs)
##  File Size List
Description: 
* List all files in the repo (just files not directories) and their sizes in a human readable format (i.e
KB, MB, GB, etc)
* List the files sorted from largest to smallest

Execution:
* execute this feature by entering 'fileSize' as argument1.
* Or follow the instructions instead

Reference: some code was taken from [StackExchange](https://unix.stackexchange.com/questions/405601/how-do-i-store-the-human-friendly-size-of-a-file-in-a-variable)
## File Filter And Sort (Custon Feature 1)
Description: 
* List all files in the repo (you can choose just files or both files and directories) that matches the requirements.
* The files can be filtered by 
    * Filename extensions
    * permissions
    * time modified
    * wheather empty or not
    * wheather hidden or not. 
* Sort by ascii code

Execution:
* execute this feature by entering 'fileFilter' as argument1.
* Or follow the instructions instead

Reference: some code was taken from [Pending](about:blank)
## File Encryption And Decryption (Custon Feature 2)
Description: 
* Encrypt selected files by changing the filename extensions to '.somefile'
* Create a log 'extEncrypt.log' to store the original filename extensions of each file (overwrite it if it already exists)
* Decrypt the files by swap back their original filename extensions refers to extEncrypt.log

Execution:
* execute this feature by entering 'enp&dep' as argument1.
* Or follow the instructions instead

Reference: some code was taken from [Pending](about:blank)
## Releases
[Dropbox](https://www.dropbox.com/s/558o9f009kcr6ly/project_analyze.sh?dl=0)