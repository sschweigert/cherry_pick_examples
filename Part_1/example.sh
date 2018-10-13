#!/bin/bash

cd /tmp
git init part1

cd part1

echo "apple" >file.txt

git add .
git commit -m "A"

echo "irrelevant" >master_file.txt
git add .
git commit -m "M1"

git checkout HEAD^
git checkout -b feature

echo "irrelevant" >feature_file.txt
git add .
git commit -m "F1"

F1_HASH=`git rev-parse HEAD`

echo "berry" >file.txt
git add .
git commit -m "F2"

git checkout master
git cherry-pick feature

echo "irrelevant" >master_file2.txt
git add .
git commit -m "M3"

git checkout feature
echo "irrelevant" >feature_file2.txt
git add .
git commit -m "F3"

git checkout master
git merge feature -m "M4"

echo -e "\n\n"
echo "Current contents of file.txt:"
cat "file.txt"

echo -e "\n\n"
echo "Close gitk to continue."

gitk

git reset --hard HEAD^

git checkout feature
git reset --hard HEAD^

echo "cherry" >file.txt
git add .
git commit -m "F3"

git checkout master
git merge feature -m "M4"

echo -e "\n\n"
echo "Now there is a conflict in file.txt:"
cat "file.txt"

echo -e "\n\n"
read -p "Press any key to continue"

git merge --abort
git checkout ${F1_HASH}
echo ${F1_HASH}

git checkout -b victim
echo "irrelevant" >victim_file.txt
git add .
git commit -m "V1"

git merge feature -m "V2"

echo -e "\n\n"
echo "feature branch merges into victim branch without conflicts"
echo "Close gitk to continue."

gitk

git merge master

echo -e "\n\n"
echo "Now there is a conflict in file.txt:"
cat "file.txt"

echo "The victim branch did not even change this file."
