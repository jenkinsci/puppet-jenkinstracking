# file name of this has to match the reporter name
require 'puppet'
require 'json'

Puppet::Reports.register_report(:jenkinstracking) do

  desc <<-DESC
Submits the execution record to Jenkins for its deployment notification plugin.
  DESC

  def process
    url = URI.parse(Puppet[:reporturl])
    headers = { "Content-Type" => "application/x-yaml" }
    options = {}
    if url.user && url.password
      options[:basic_auth] = {
        :user => url.user,
        :password => url.password
      }
    end
    use_ssl = url.scheme == 'https'

    conn = Puppet::Network::HttpPool.http_instance(url.host, url.port, use_ssl)
    response = conn.get(suffix(url.path,"crumbIssuer/api/json"), headers)
    if response.kind_of?(Net::HTTPSuccess)
      # if crumb is not found on the response, ignore it. The error will be reported in the next POST call anyway.
      json=JSON.parse(response.body)
      headers[json['crumbRequestField']] = json['crumb']
    end
    
    # post the actual payload
    response = conn.post(suffix(url.path,"puppet/report"), self.to_yaml, headers)
    unless response.kind_of?(Net::HTTPSuccess)
      Puppet.err "Unable to submit report to #{Puppet[:reporturl].to_s} [#{response.code}] #{response.msg}"
    end
  end

  def suffix(a,b)
    if a.end_with? "/"
      a+b
    else
      "#{a}/#{b}"
    end
  end
end
