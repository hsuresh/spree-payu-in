class PayuInCallbacksController < Spree::BaseController
  include ActiveMerchant::Billing::Integrations
  skip_before_filter :verify_authenticity_token

  def notify
    retrieve_details
    render :nothing => true
  end

  private
    def retrieve_details
    end
end