#!/bin/bash -e

for x in bzr git
do
    if ! which $x > /dev/null
    then
        echo "$x is needed, but not installed. Fixing."
        sudo apt-get install $x
    fi
done

if ! which git > /dev/null
then
    echo "bzr is needed, but not installed. Fixing."
    sudo apt-get install bzr
fi
if [ ! -e venv ]
then
    virtualenv venv
    . venv/bin/activate
    pip install -e bzr+http://bazaar.launchpad.net/~soren/python-jenkins/add-crumb#egg=jenkins
    pip install pyyaml
    pip install -e git+https://github.com/JioCloud/jenkins-job-builder#egg=jenkins_job_builder
    deactivate
fi

tmp=$(mktemp)
cat *.yaml > "${tmp}"

. venv/bin/activate

if [ $# -eq 0 ]
then
    delete_old="--delete-old "
else
    delete_old=""
fi

if [ -n "$CONFIG" ]
then
    confopt="--conf=${CONFIG}"
fi

if [ "$1" = "test" ]
then
    jenkins-jobs $confopt test ${tmp} -o $2
else
    jenkins-jobs $confopt update ${delete_old} ${tmp} $@
fi

deactivate

rm "${tmp}"
