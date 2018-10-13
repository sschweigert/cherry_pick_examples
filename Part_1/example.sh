#!/bin/bash

# Create part1 repo in /tmp/
cd /tmp
git init part1

cd part1

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

echo "irrelevant" >feature_file.txt
git add .
git commit -m "F1"

# Save F1 hash for later, for "victim" example
F1_HASH=`git rev-parse HEAD`

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
echo "irrelevant" >feature_file2.txt
git add .
git commit -m "F3"

# Merge feature into master
git checkout master
git merge feature -m "M4"

echo -e "\n\n"
echo "Current contents of file.txt:"
cat "file.txt"

echo -e "\n\n"
echo "Close gitk to continue."

gitk

# Undo the merge so that the second example can be demonstrated
git reset --hard HEAD^

git checkout feature
git reset --hard HEAD^

# Change the file again on feature branch
echo "cherry" >file.txt
git add .
git commit -m "F3"

# Try the merge again
git checkout master
git merge feature -m "M4"

# Demonstrate the conflict this caused
echo -e "\n\n"
echo "Now there is a conflict in file.txt:"
cat "file.txt"

echo -e "\n\n"
read -p "Press any key to continue"


git merge --abort

# Create the victim branch based on the F1 hash
git checkout ${F1_HASH}
git checkout -b victim

# Make some irrelevant commit to victim branch
echo "irrelevant" >victim_file.txt
git add .
git commit -m "V1"

# Merge the feature branch into victim branch
git merge feature -m "V2"

# Demonstrate that the merge succeeded without conflicts
echo -e "\n\n"
echo "feature branch merges into victim branch without conflicts"
echo "Close gitk to continue."

gitk

# Attempt to merge master into victim branch
git merge master

# Demonstrate the merge caused strange conflicts
echo -e "\n\n"
echo "Now there is a conflict in file.txt:"
cat "file.txt"

echo "The victim branch did not even change this file."
