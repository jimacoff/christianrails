class Whitelist
  def initialize
    @ips = [ ENV["CRON_IP"] ]
  end

  def matches?(request)
    @ips.include?(request.remote_ip)
  end

end
