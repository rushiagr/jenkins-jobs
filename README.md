Job descriptions for Jenkins
============================

This repository is pulled down by this job:

  http://jiocloud.rustedhalo.com:8080/job/jobs-refresh/

After being pulled, Jenkins runs `./apply.sh` which:
 * creates a virtualenv (unless it already exists),
 * concatenates `*.yaml` into a single file,
 * and then passes that file to jenkins-job-builder.
