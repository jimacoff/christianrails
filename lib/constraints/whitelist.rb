class Whitelist
  def initialize
    @ips = Whitelist.retrieve_ips
  end

  def matches?(request)
    @ips.include?(request.remote_ip)
  end

  def retrieve_ips
    [ ENV["CRON_IP"] ]
  end
end
