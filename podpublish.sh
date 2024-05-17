#!/bin/bash

# parameters needed
#$1 new version
#$2 repo
if [ "$#" -ne 1 ]; then
    echo "-- new version needed"
    exit 1
fi

# check git status
if ! git diff-index --quiet HEAD --; then
    echo "-- Git dirty"
    exit 1
fi

PODSPEC_FILE="$(find . -regex '^.*\.podspec\.json' | head -n 1)"

if [ -z "$PODSPEC_FILE" ]; then
    echo "-- No podspec file found"
    exit 1
fi

echo "-- Publishing version $1"
sed -i "" "s/\"version\": \"\(.*\)\",/\"version\": \"$1\",/g" "$PODSPEC_FILE"
sed -i "" "s/\"tag\": \"\(.*\)\"/\"tag\": \"$1\"/g" "$PODSPEC_FILE"

echo "-- Commit changes"
git add . && git commit -m "v $1"

echo "-- Pushing changes"
git push

echo "-- Adding tag $1"
git tag "$1"

echo "-- Pushing tag $1"
git push origin "$1"

echo "-- Pushing repo"
pod repo push RVPods "$PODSPEC_FILE" --allow-warnings --use-libraries --verbose
echo "-- Pod published"
