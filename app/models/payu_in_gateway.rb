require 'digest/sha2'

class PayuInGateway
  def initialize(hash)
    puts "Opts: #{hash.inspect}"
    @opts = hash
  end
  
  def external_payment_url
    "#{@opts[:url]}/_payment.php"
  end
  
  def merchant_id
    @opts[:merchant_id]
  end

  def salt
    @opts[:salt]
  end
  
  def hash(order)
#    Digest::SHA512.hexdigest("#{self.merchant_id}|#{order.id}|#{order.total.to_f}|#{order.number}|#{order.bill_address.firstname}|#{order.user.email}|||||||||||#{self.salt}")
    Digest::SHA512.hexdigest("#{self.merchant_id}|#{order.id}|#{order.total.to_f}|#{order.number}|#{order.bill_address.firstname}|#{order.user.email}|#{self.salt}")
  end
end