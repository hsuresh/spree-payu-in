class PayuInCallbacksController < Spree::BaseController
  include ActiveMerchant::Billing::Integrations
  skip_before_filter :verify_authenticity_token

  def notify
    if params[:status] == 'failed'
      render ''
    elsif params[:status] == 'canceled'
    else
      puts "Payment successful. payu_in_notify:#{params.inspect}"
      payment = @order.checkout.payments.create(:amount => ppx_auth_response.params["gross_amount"].to_f,
                                                :source => paypal_account,
                                                :payment_method_id => params[:payment_method_id])

      retrieve_details
      render :nothing => true
    end
  end

  private
    def retrieve_details
    end
end