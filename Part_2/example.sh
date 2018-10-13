#!/bin/bash

# Create part2 repo in /tmp/
cd /tmp
git init part2

cd part2

# Initialize the file to apple
echo "apple" >file.txt

git add .
git commit -m "A"

# Make some irrelevant changes on master and feature branch
echo "irrelevant" >master_file.txt
git add .
git commit -m "M1"

git checkout HEAD^
git checkout -b feature

echo "irrelev-" >feature_file.txt
git add .
git commit -m "F1"

# Change file to berry on feature branch
echo "berry" >file.txt
git add .
git commit -m "F2"

# Cherry pick the change to berry onto master branch
git checkout master
git cherry-pick feature

# Add some irrelevant changes to master and feature branch
echo "irrelevant" >master_file2.txt
git add .
git commit -m "M3"

git checkout feature
echo "irrelevant" >feature_file.txt
echo "apple" >file.txt
git add .
git commit -m "F3"

# Merge feature into master
git checkout master
git merge feature -m "M4"

# Demonstrate the file contains the wrong value
echo -e "\n\n"
echo "Current contents of file.txt:"
cat "file.txt"

echo -e "\n\n"
echo "Close gitk to continue."

gitk --all

# Merge master into feature
git checkout feature
git merge master --no-ff -m "F4"

# Demonstrate the wrong value was propagated to feature branch as well
echo -e "\n\n"
echo "Current contents of file.txt:"
cat "file.txt"

echo -e "\n\n"
echo "Close gitk to continue."

gitk --all
