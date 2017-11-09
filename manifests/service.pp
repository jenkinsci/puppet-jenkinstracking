# This subclass optionally manages the Puppet server service, by any name.  In
# order for reporturl changes to be picked up, the service must be restarted.
# The service does not exist on stand-alone nodes.
#
# @summary Enables restarting the Puppet server upon configuration change.
#
# @example Disable management of the Puppet server's service
#  ---
#  classes:
#    - jenkinstracking
#
#  # You must specify your own Jenkins report submission URL, even if you manage
#  # your puppet.conf and puppetserver.conf files by other means.
#  jenkinstracking::report_url: https://report_user:api_token@jenkins-server/puppet/report
#  jenkinstracking::manage_puppetserver_service: false
#
class jenkinstracking::service {
  if ! $jenkinstracking::stand_alone
    and $jenkinstracking::manage_puppetserver_service
  {
    # The Puppet server's service may have already been defined elsewhere.
    if !defined(Service[$jenkinstracking::puppetserver_service_name]) {
      service { $jenkinstracking::puppetserver_service_name:
        ensure    => running,
        enable    => true,
      }
    }

    # Whether the service was defined here or elsewhere, it must be notified of
    # changes to configuration settings that require a restart to be effective.
    if $jenkinstracking::manage_report_url {
      Ini_setting['puppet.conf/jenkins-reporturl']
      ~> Service[$jenkinstracking::puppetserver_service_name]
    }

    if $jenkinstracking::manage_puppetserver_lib_path {
      Hocon_setting['merged-puppetserver-ruby-lib-path']
      ~> Service[$jenkinstracking::puppetserver_service_name]
    }
  }
}
# vim: syntax=puppet:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
