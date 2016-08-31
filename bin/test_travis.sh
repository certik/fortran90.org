#! /usr/bin/env bash

set -e
set -x

make html

git fetch origin gh-pages:gh-pages
git checkout gh-pages
cp -r _build/html/* .
rm -r _build
git add .
git config user.name "Travis-CI"
git config user.email "noreply@travis-ci.org"
git commit -a -m "Automatic commit"

set +x
if [[ "${SSH_PRIVATE_KEY}" == "" ]]; then
    echo "Not deploying because SSH_PRIVATE_KEY is empty."
    exit 0
fi
# Generate the private/public key pair using:
#
#     ssh-keygen -f deploy_key -N ""
#
# then set the $SSH_PRIVATE_KEY environment variable in the CI (Travis-CI,
# GitLab-CI, ...) to the base64 encoded private key:
#
#     cat deploy_key | base64 -w0
#
# and add the public key `deploy_key.pub` into the target git repository (with
# write permissions).

eval "$(ssh-agent -s)"
ssh-add <(echo "$SSH_PRIVATE_KEY" | base64 --decode)
set -x


# Only deploy when run on master (i.e. when the PR gets merged with master),
# from the first Travis build job.

ACTUAL_TRAVIS_JOB_NUMBER=`echo $TRAVIS_JOB_NUMBER| cut -d'.' -f 2`
if [[ "$TRAVIS_PULL_REQUEST" == "false" ]] && [[ "$ACTUAL_TRAVIS_JOB_NUMBER" == "1" ]] && [[ "$TRAVIS_BRANCH" == "master" ]]; then
	git push git@github.com:certik/fortran90.org gh-pages
fi
