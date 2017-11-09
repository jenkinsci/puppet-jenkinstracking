# Optionally manages the [main|master]reports and reporturl entries of
# puppet.conf to add or remove the jenkinstracking report processor.  See the
# init.pp file for usage examples.
class jenkinstracking::config {
  if $jenkinstracking::stand_alone {
    $ini_section = 'main'
  } else {
    $ini_section = 'master'
  }

  if $jenkinstracking::manage_report_processor {
	  ini_subsetting { "puppet.conf/${ini_section}/reports/jenkinstracking":
	    ensure               => $jenkinstracking::report_processor_ensure,
	    path                 => $jenkinstracking::puppet_conf_file,
	    section              => $ini_section,
	    setting              => 'reports',
	    subsetting           => 'jenkinstracking',
	    subsetting_separator => ',',
	  }
	}

  if $jenkinstracking::manage_report_url {
    ini_setting { "puppet.conf/${ini_section}/reporturl":
      ensure  => $jenkinstracking::report_url_ensure,
      path    => $jenkinstracking::puppet_conf_file,
      section => $ini_section,
      setting => 'reporturl',
      value   => $jenkinstracking::report_url,
    }
  }
}
# vim: syntax=puppet:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
