Puppet Jenkins tracking module
======================

Jenkins has this concept of "artifact fingerprinting" where a build might say "archive foo.war as an artifact" and "keep fingerprints of my build artifacts".

In a continuous deployment/delivery case where a build artifact (say `foo.war`) might be passed from build to build in Jenkins, Jenkins will in fact track that file's progression through a pipeline. If one were to then deploy that file with Puppet, there would be no record of when/where that file is deployed, as it happens outside Jenkins.

The `track` resource basically generates data for a Puppet report containing the md5 of the tracked file, such that it can be reported back to Jenkins so Jenkins can display which files went to what machines, and when, for a complete build and delivery pipeline.

    class foo {
        ... other puppet resources that produce foo.war ...
    
        track { '/var/lib/foo.war':
        }
    }

In the above example, the `track` resource captues the fingerprint of `/var/lib/foo.war` (which presumably is produced by other puppet resources). Note that `file` resources are automatically tracked, so `track` is only necessary where a file is produced by unusual means, such as unzipping an archive in an `exec` resource, a file installed through package installation, etc.

See [deployment notification plugin](https://wiki.jenkins-ci.org/display/JENKINS/Deployment+Notification+Plugin) and [puppet plugin](https://wiki.jenkins-ci.org/display/JENKINS/Puppet+Plugin) for how these things work together.

This module is [being considered](https://github.com/jenkinsci/puppet-jenkins/issues/110) for an inclusion into [the puppet-jenkins module](https://github.com/jenkinsci/puppet-jenkins).

## Integrating the jenkinstracking Report Type

This module also provides a custom report which your Puppet servers can use to publish tracking data to your Jenkins server.  Integration is very simple.  While you *could* just hand-edit your puppet.conf file to accomplish this integration and you *could* just hand-install the required set of Jenkins plug-ins, that's just not wise.  To enjoy full automation and peace-of-mind that the configuration will be -- and stay -- correct, you need only classify your Puppet server with this module and set -- at minimum -- the Puppet report submission URL for your Jenkins server.  As an added bonus, the examples that follow will also illustrate how to automatically handle installing all the required Jenkins plug-ins.

**Note**:  Puppet modules and Jenkins plug-ins are changing all the time, as well as their dependencies.  The lists shown here were accurate at the time this document was authored.  Be sure to sanity-check this content if you find this to be outdated.  Even better, please open a pull-request to have this documentation updated when you find inevitable discrepancies!


### The r10k Puppetfile

To enable Puppet-Jenkins integration, the minimum set of modules for your Puppetfile include (while you may only want `jenkins` and `jenkinsracking`, they depend on other Puppet modules):

```
mod "camptocamp/systemd"
mod "puppet/archive"
mod "puppet/zypprepo"
mod "puppetlabs/apt"
mod "puppetlabs/inifile"
mod "puppetlabs/java"
mod "puppetlabs/stdlib"
mod "puppetlabs/transition"
mod "rtyler/jenkins"
mod "wwkimball/jenkinstracking",
  :git => https://github.com/wwkimball/puppet/jenkinstracking.git
```

### YAML Configuration Example

If you are using the popular Hiera-as-ENC pattern, the following examples illustrate the least amount of configuration you'd need to achieve integration between Puppet and Jenkins for deployment artifact tracking:

#### Minimum YAML configuration for your Puppet server

This example classifies your Puppet servers with the `jenkinstracking` Puppet module.  It also illustrates the least amount of configuration that is required for the Puppet servers to begin publishing tracked resources to your Jenkins server.  Of course, this class provides more configuration options but -- omitting `report_url` -- the defaults are typically enough to get going out-of-the-box.

```
---
classes:
  - jenkinstracking

# You must specify your own Jenkins report submission URL, even if you manage
# your puppet.conf file by other means.
jenkinstracking::report_url: https://report_user:api_token@jenkins-server/puppet/report
```

#### Minimum YAML configuration for your Jenkins server

This example classifies your Jenkins server with the `jenkins` Puppet module.  It also illustrates the bare minimum required configuration to enable Puppet-Jenkins integration.  The very long list of entries for `plugin_hash` is entirely required due to plug-in inter-dependencies.  To wit, even if you don't use VMWare's vSphere products, you must still install the `vsphere-cloud` plug-in because it is part of the dependency tree for the `puppet` plug-in.  Your actual list of plug-ins -- and their dependencies -- will likely be considerably longer than this; these are merely the bare minimum required to enable Puppet-Jenkins integration.

```
classes:
  - jenkins

jenkins::plugin_hash:
  # Provides the jenkins/puppet/report access point for Puppet to publish reports
  'puppet': {}

  # Required by the puppet plug-in
  'deployment-notification': {}

  # Required by deployment-notification
  'apache-httpcomponents-client-4-api': {}
  'cloudbees-folder': {}
  'config-file-provider': {}
  'credentials': {}
  'display-url-api': {}
  'javadoc': {}
  'job-dsl': {}
  'jsch': {}
  'junit': {}
  'mailer': {}
  'managed-scripts': {}
  'maven-plugin': {}
  'node-iterator-api': {}
  'project-inheritance': {}
  'promoted-builds': {}
  'rebuild': {}
  'scm-api': {}
  'script-security': {}
  'ssh-credentials': {}
  'ssh-slaves': {}
  'structs': {}
  'token-macro': {}
  'vsphere-cloud': {}
  'workflow-api': {}
  'workflow-basic-steps': {}
  'workflow-job': {}
  'workflow-step-api': {}
  'workflow-support': {}
```
