require 'digest/md5'

Puppet::Type.newtype(:track) do
  @doc = %q{Track MD5 checksums of files, so that external tracking tools like
  Jenkins deployment notification plugin can find out what files are in the system.

    Example:

      track { '/usr/share/foo/foo.war'}
  }

  newparam(:name) do
    desc "Path of the file name to track."
    isnamevar
  end

  #newparam(:recursive, :boolean => true, :parent => Puppet::Parameter::Boolean) do
  #  desc "Recursively track all the files in this directory"
  #end

  newproperty(:md5) do |property|
    # we tell puppet the current property value in the system is always :notcomputed,
    # then we set the default value so that puppet thinks the manifests want to change
    # this value to :computed. That's how we force the sync method to run every single time.
    defaultto :computed
    def retrieve
      return :notcomputed
    end

    def change_to_s(cur,newv)
      "{md5}#@md5"
    end

    def sync
      digest = Digest::MD5.new
      File.open(self.resource[:name], 'rb') do |file|
        while content = file.read(4192)
          digest << content
        end
      end

      @md5 = digest.hexdigest
    end
  end

  # respond to refresh event, I think
  def refresh
    # is this really needed?
    self.property(:md5).sync
  end

  def self.instances
    # is this really needed?
    []
  end

  def output
    # is this really needed?
    if self.property(:md5).nil?
      return nil
    else
      return self.property(:md5).output
    end
  end
end