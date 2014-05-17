puppet-jenkinstracking
======================

Jenkins has this concept of "artifact fingerprinting" where a build might say "archive foo.war as an artifact" and "keep fingerprints of my build artifacts".

In a continuous deployment/delivery case where a build artifact (say `foo.war`) might be passed from build to build in Jenkins, Jenkins will in fact track that file's progression through a pipeline. If one were to then deploy that file with Puppet, there would be no record of when/where that file is deployed, as it happens outside Jenkins.

The `track` resource basically generates data for a Puppet report containing the md5 of the tracked file, such that it can be reported back to Jenkins so Jenkins can display which files went to what machines, and when, for a complete build and delivery pipeline.

See [deployment notification plugin](https://wiki.jenkins-ci.org/display/JENKINS/Deployment+Notification+Plugin) and [puppet plugin](https://wiki.jenkins-ci.org/display/JENKINS/Puppet+Plugin) for how these things work together.

This module is [being considered](https://github.com/jenkinsci/puppet-jenkins/issues/110) for an inclusion into [the puppet-jenkins module](https://github.com/jenkinsci/puppet-jenkins).
