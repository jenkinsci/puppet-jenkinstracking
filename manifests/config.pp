# Optionally manages the [main|master]reports and reporturl entries of
# puppet.conf to add or remove the jenkinstracking report processor.  See the
# init.pp file for usage examples.
#
# @summary Manages settings necessary to affect report configuration.
#
# @example Completely remove the jenkinstracking report processor
#  ---
#  classes:
#    - jenkinstracking
#
#  # You must still specify your own Jenkins report submission URL, even if you
#  # manage your puppet.conf and puppetserver.conf files by other means.
#  jenkinstracking::report_url: http://anything-that-looks/like/a-url
#  jenkinstracking::report_processor_ensure: absent
#  jenkinstracking::report_url_ensure: absent
#
# @example Disable management of the puppet.conf and puppetserver.conf files
#  ---
#  classes:
#    - jenkinstracking
#
#  # You must still specify your own Jenkins report submission URL, even if you
#  # manage your puppet.conf and puppetserver.conf files by other means.
#  jenkinstracking::report_url: http://anything-that-looks/like/a-url
#  jenkinstracking::manage_puppetserver_lib_path: false
#  jenkinstracking::manage_report_processor: false
#  jenkinstracking::manage_report_url: false
#
class jenkinstracking::config {
  # The applicable section of puppet.conf differs whether the node is
  # stand-alone (as opposed to a Puppet server).
  if $jenkinstracking::stand_alone {
    $ini_section = 'main'
  } else {
    $ini_section = 'master'
  }

  if $jenkinstracking::manage_report_processor {
	  ini_subsetting { "puppet.conf/${ini_section}/reports/jenkinstracking":
	    ensure               => $jenkinstracking::report_processor_ensure,
	    path                 => $jenkinstracking::puppet_agent_conf_file,
	    section              => $ini_section,
	    setting              => 'reports',
	    subsetting           => 'jenkinstracking',
	    subsetting_separator => ',',
	  }
	}

  if $jenkinstracking::manage_report_url {
    ini_setting { 'puppet.conf/jenkins-reporturl':
      ensure  => $jenkinstracking::report_url_ensure,
      path    => $jenkinstracking::puppet_agent_conf_file,
      section => $ini_section,
      setting => 'reporturl',
      value   => $jenkinstracking::report_url,
    }
  }

  if ! $jenkinstracking::stand_alone
    and $jenkinstracking::manage_puppetserver_lib_path
  {
    hocon_setting { 'merged-puppetserver-ruby-lib-path':
      ensure  => $jenkinstracking::merged_lib_path_ensure,
      path    => $jenkinstracking::puppetserver_conf_file,
      setting => 'jruby-puppet.ruby-load-path',
      value   => $jenkinstracking::puppet_agent_lib_path,
      type    => 'array_element',
    }
  }
}
# vim: syntax=puppet:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
