require 'bigdecimal'

module Spree::PayuIn
  include ERB::Util
  include ActiveMerchant::RequiresParameters


  def self.included(target)
    target.before_filter :redirect_to_payu_in, :only => [:update]
    target.skip_before_filter :verify_authenticity_token, :only=> [:gateway_callback]
  end

  def payu_checkout
    load_order
    gateway = payment_method.provider
    redirect_to gateway.payment_page_url(@order)
  end

  def payu_in_payment
    load_order
    @gateway = payment_method.provider
    puts "Gateway external url: #{@gateway.external_payment_url}"
    render "checkout/_payment_options"
  end

  def gateway_callback
    @order = Order.find(params[:txnid])
    if params[:status] == 'failed'
      render 'checkout/failed'
    elsif params[:status] == 'canceled'
      render 'checkout/failed'
    else
      payment = @order.payments.create(:amount => BigDecimal.new(params["amount"]),
                                                :source => PayuPayment.new_from(params),
                                                :payment_method_id => params['udf1'])

      @order.state = 'payment'
      if @order.next
        state_callback(:after)
      else
        flash[:error] = I18n.t(:payment_processing_failed)
        respond_with(@order, :location => checkout_state_path(@order.state))
        return
      end

      if @order.state == "complete" || @order.completed?
        flash[:notice] = I18n.t(:order_processed_successfully)
        flash[:commerce_tracking] = "nothing special"
        respond_with(@order, :location => completion_route)
      else
        respond_with(@order, :location => checkout_state_path(@order.state))
      end
    end
  end

  def gateway_callback
    @order = Order.find(params[:txnid])
    if params[:status] == 'failed'
      render 'checkout/failed'
    elsif params[:status] == 'canceled'
      render 'checkout/failed'
    else
      puts "Payment successful. payu_in_notify:#{params.inspect}"
      payment = @order.payments.create(:amount => BigDecimal.new(params["amount"]),
                                                :source => PayuPayment.new_from(params),
                                                :payment_method_id => params['udf1'])

      @order.state = 'payment'
      if @order.next
        state_callback(:after)
      else
        flash[:error] = I18n.t(:payment_processing_failed)
        respond_with(@order, :location => checkout_state_path(@order.state))
        return
      end

      if @order.state == "complete" || @order.completed?
        flash[:notice] = I18n.t(:order_processed_successfully)
        flash[:commerce_tracking] = "nothing special"
        respond_with(@order, :location => completion_route)
      else
        respond_with(@order, :location => checkout_state_path(@order.state))
      end
    end
  end

  private
  def redirect_to_payu_in
    return unless params['state'] == "address"

    if @order.update_attributes(object_params)
      load_order
      payment_method = PaymentMethod.find(params[:order][:payments_attributes].first[:payment_method_id])

      if payment_method.kind_of?(Gateway::PayuIn)
        redirect_to payu_in_payment_order_checkout_url(@order, :payment_method_id => payment_method)
      end
    else
      respond_with(@order) { |format| format.html { render :edit } }
    end
  end
  
  def payment_method
    PaymentMethod.find(params[:payment_method_id])
  end
end