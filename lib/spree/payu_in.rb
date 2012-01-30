module Spree::PayuIn
  include ERB::Util
  include ActiveMerchant::RequiresParameters

  def self.included(target)
    puts "Including payuin: #{target}"
    target.before_filter :redirect_to_payu_in, :only => [:update]
  end

  def payu_checkout
    load_order
    gateway = payment_method.provider
    redirect_to gateway.payment_page_url(@order)
  end

  def payu_in_payment
    load_order
    @gateway = payment_method.provider
    render "payment/gateway/payu_in_payment"
  end

  private
  def redirect_to_payu_in
    puts "PayuIn Redirection:1"
    return unless params['state'] == "payment"
    puts "PayuIn Redirection...2"
    load_order
    payment_method = PaymentMethod.find(params[:order][:payments_attributes].first[:payment_method_id])
    puts "PayuIn Redirection...3 #{payment_method.class.name}"

    if payment_method.kind_of?(Gateway::PayuIn)
      redirect_to payu_in_payment_order_checkout_url(@order, :payment_method_id => payment_method)
    end
  end
  
  def payment_method
    PaymentMethod.find(params[:payment_method_id])
  end
end