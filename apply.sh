#!/bin/bash -e

if [ ! -e venv ]
then
    virtualenv venv
    . venv/bin/activate
    pip install -e bzr+http://bazaar.launchpad.net/~soren/python-jenkins/add-crumb#egg=jenkins
    pip install pyyaml
    pip install -e git+https://github.com/openstack-infra/jenkins-job-builder#egg=jenkins_job_builder
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

jenkins-jobs $confopt update ${delete_old} ${tmp} $@

deactivate

rm "${tmp}"
