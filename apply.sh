#!/bin/bash -e

if [ ! -e venv ]
then
    virtualenv env
    . venv/bin/activate
    pip install -e bzr+http://bazaar.launchpad.net/~soren/python-jenkins/add-crumb#egg=jenkins
    pip install pyyaml
    pip install -e git+https://github.com/openstack-infra/jenkins-job-builder#egg=jenkins_job_builder
	deactivate
fi

tmp=$(mktemp)
cat *.yaml > "${tmp}"

. venv/bin/activate

jenkins-jobs update --delete-old ${tmp} $@

deactivate

rm "${tmp}"
