# Manage the installation of the jenkinstracking report processor on the Puppet
# server.
#
# @param manage_report_processor Indicates whether to manage the reports key of
#  the puppet.conf file on this node.  When `false`, the setting will neither be
#  added nor removed.  So, if you are trying to *remove* this report processor,
#  you must still set `manage_report_processor` to `true` for a setting of
#  `report_processor_ensure` of `absent` to be meaningful.
# @param manage_report_url Indicates whether to manage the reporturl key of the
#  puppet.conf file on this node.  When `false`, this setting will neither be
#  added nor removed.  So, if you are trying to *remove* this URL, you must
#  still set `manage_report_url` to `true` for a setting of `report_url_ensure`
#  of `absent` to be meaningful.
# @param report_url The complete URL to your Jenkins server's Puppet reports
#  access-point.  This is usually of the form
#  `https://report_user:api_token@jenkins-server/puppet/report`.
# @param report_url_ensure Indicate whether to keep the reporturl setting in or
#  out of the puppet.conf file.
# @param puppet_conf_file Fully-qualified path to the puppet.conf file.
# @param report_processor_ensure Indicate whether to keep the jenkinstracking
#  report processor in or out of the puppet.conf file.
# @param stand_alone Indicates whether the node is stand-alone (no Puppet
#  server).
#
# @example Default: keep the jenkinstracking report processor active
#  ---
#  classes:
#    - jenkinstracking
#
#  # You must specify your own Jenkins report submission URL, even if you manage
#  # your puppet.conf file by other means.
#  jenkinstracking::report_url: https://report_user:api_token@jenkins-server/puppet/report
#
# @example Completely remove the jenkinstracking report processor
#  ---
#  classes:
#    - jenkinstracking
#
#  # You must still specify your own Jenkins report submission URL, even if you
#  # manage your puppet.conf file by other means.
#  jenkinstracking::report_url: http://anything-that-looks/like/a-url
#  jenkinstracking::report_processor_ensure: absent
#  jenkinstracking::report_url_ensure: absent
#
# @example Disable management of the puppet.conf file
#  ---
#  classes:
#    - jenkinstracking
#
#  # You must still specify your own Jenkins report submission URL, even if you
#  # manage your puppet.conf file by other means.
#  jenkinstracking::report_url: http://anything-that-looks/like/a-url
#  jenkinstracking::manage_report_processor: false
#  jenkinstracking::manage_report_url: false
#
class jenkinstracking(
  Boolean                   $manage_report_processor,
  Boolean                   $manage_report_url,
  Stdlib::Absolutepath      $puppet_conf_file,
  Enum['present', 'absent'] $report_processor_ensure,
  Enum['present', 'absent'] $report_url_ensure,
  Stdlib::HTTPUrl           $report_url,
  Boolean                   $stand_alone,
) {
  class { '::jenkinstracking::config': }
  -> Class['jenkinstracking']
}
# vim: syntax=puppet:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
