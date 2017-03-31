require 'netaddr'

class Base

  def valid_cidr
    net = nil
    begin
      net = NetAddr::CIDR.create(cidr)
    rescue
      errors.add(:cidr, "is not valid (e.g. 10.0.0.0/24)")
      return
    end
    errors.add(:cidr, "calculated base address does not equal given prefix") unless net.base == net.ip
  end

  def populate_start_and_end
    net = NetAddr::CIDR.create(cidr)
    self.start_address = NetAddr.ip_to_i(net.base)
    self.end_address = NetAddr.ip_to_i(net.broadcast)
  end

  def populate_address
    net = NetAddr::CIDR.create(cidr)
    self.address = NetAddr.ip_to_i(net.ip)
  end

end
