# Manage the installation of the jenkinstracking report processor on the Puppet
# server or stand-alone nodes.
#
# @param manage_puppetserver_lib_path Indicates whether to manage the presence
#  of the Puppet agent's Ruby library path within the load path of the Puppet
#  server's configuration file, `puppetserver_conf_file`.  When `false`, the
#  setting will be neither added nor removed.  So, if you are trying to *remove*
#  the value, you must still set this to `true` for an effective setting of
#  `merged_lib_path_ensure` to `absent`.  Ignored (assumed to be
#  `false`) when `stand_alone` is `true`.  The default value is controlled via
#  the Hiera data file that applies to your infrastructure; see hiera.yaml for
#  guidance as to which YAML file(s) will apply.
# @param manage_puppetserver_service Indicates whether to restart the Puppet
#  server whenever changes are affected which require a restart to take effect.
#  Ignored (assumed to be `false`) when `stand_alone` is `true`.  The default
#  value is controlled via the Hiera data file that applies to your
#  infrastructure; see hiera.yaml for guidance as to which YAML file(s) will
#  apply.
# @param manage_report_processor Indicates whether to manage the reports key of
#  the `puppet_agent_conf_file` file on this node.  When `false`, the setting
#  will be neither added nor removed.  So, if you are trying to *remove* this
#  report processor, you must still set `manage_report_processor` to `true` for
#  an effective setting of `report_processor_ensure` to `absent`.  The default
#  value is controlled via the Hiera data file that applies to your
#  infrastructure; see hiera.yaml for guidance as to which YAML file(s) will
#  apply.
# @param manage_report_url Indicates whether to manage the reporturl key of the
#  `puppet_agent_conf_file` file on this node.  When `false`, this setting will
#  be neither added nor removed.  So, if you are trying to *remove* this URL,
#  you must still set `manage_report_url` to `true` for an effective setting of
#  `report_url_ensure` to `absent`.  The default value is controlled via the
#  Hiera data file that applies to your infrastructure; see hiera.yaml for
#  guidance as to which YAML file(s) will apply.
# @param merged_lib_path_ensure Indicate whether to keep the Puppet agent's Ruby
#  library path in or out of the Puppet server's Ruby load path.  Ignored
#  (assumed to be `false`) when `stand_alone` is `true`.  The default value is
#  controlled via the Hiera data file that applies to your infrastructure; see
#  hiera.yaml for guidance as to which YAML file(s) will apply.
# @param puppet_agent_lib_path Path to the Puppet agent's Ruby library path.
#  Relevant only when `stand_alone` is `false` and this module is being applied
#  to a Puppet server.  The default value is controlled via the Hiera data file
#  that applies to your infrastructure; see hiera.yaml for guidance as to which
#  YAML file(s) will apply.
# @param puppet_agent_conf_file Fully-qualified path to the puppet.conf file.
# @param puppetserver_conf_file Fully-qualified path to the puppetserver.conf
#  file.
# @param puppetserver_service_name The precise name of the Puppet server's
#  service / resource.  Ignored when `stand_alone` is `true`.  The default value
#  is controlled via the Hiera data file that applies to your infrastructure;
#  see hiera.yaml for guidance as to which YAML file(s) will apply.
# @param report_url The complete URL to your Jenkins server's Puppet reports
#  access-point.  This is usually of the form
#  `https://report_user:api_token@jenkins-server/puppet/report`.  There is no
#  default value because virutally every consumer of this module will need a
#  unique value.
# @param report_url_ensure Indicate whether to keep the reporturl setting in or
#  out of the puppet.conf file.  The default value is controlled via the Hiera
#  data file that applies to your infrastructure; see hiera.yaml for guidance as
#  to which YAML file(s) will apply.
# @param report_processor_ensure Indicate whether to keep the jenkinstracking
#  report processor in or out of the `puppet_agent_conf_file` file.  The default
#  value is controlled via the Hiera data file that applies to your
#  infrastructure; see hiera.yaml for guidance as to which YAML file(s) will
#  apply.
# @param stand_alone Indicates whether the node is stand-alone (no Puppet
#  server).  The default value is controlled via the Hiera data file that
#  applies to your infrastructure; see hiera.yaml for guidance as to which YAML
#  file(s) will apply.
#
# @example Default: keep the jenkinstracking report processor active
#  ---
#  classes:
#    - jenkinstracking
#
#  # You must specify your own Jenkins report submission URL, even if you manage
#  # your puppet.conf and puppetserver.conf files by other means.
#  jenkinstracking::report_url: https://report_user:api_token@jenkins-server/puppet/report
#
# @example Deploy to a stand-alone (AKA master-less) node
#  ---
#  classes:
#    - jenkinstracking
#
#  # You must specify your own Jenkins report submission URL, even if you manage
#  # your puppet.conf and puppetserver.conf files by other means.
#  jenkinstracking::report_url: https://report_user:api_token@jenkins-server/puppet/report
#  jenkinstracking::stand_alone: true
#
class jenkinstracking(
  Boolean                   $manage_puppetserver_lib_path,
  Boolean                   $manage_puppetserver_service,
  Boolean                   $manage_report_processor,
  Boolean                   $manage_report_url,
  Enum['present', 'absent'] $merged_lib_path_ensure,
  Stdlib::Absolutepath      $puppet_agent_lib_path,
  Stdlib::Absolutepath      $puppet_agent_conf_file,
  Stdlib::Absolutepath      $puppetserver_conf_file,
  String[6]                 $puppetserver_service_name,
  Enum['present', 'absent'] $report_processor_ensure,
  Enum['present', 'absent'] $report_url_ensure,
  Stdlib::HTTPUrl           $report_url,
  Boolean                   $stand_alone,
) {
  class { '::jenkinstracking::config': }
  -> class { '::jenkinstracking::service': }
  -> Class['jenkinstracking']
}
# vim: syntax=puppet:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
