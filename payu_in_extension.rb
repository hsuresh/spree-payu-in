class PayuInExtension < Spree::Extension
  version "0.1"
  description "Payu.in integration for spree"
#  url "http://yourwebsite.com/paypal_express"

  def activate
    BillingIntegration::PayuIn.register


#    require File.join(SpreePayuInExtension.root, "app", "models", "exte")

    CheckoutsController.class_eval do
      include Spree::PayuIn
    end

    Checkout.class_eval do
      private
        def complete_order
          order.complete!
          if Spree::Config[:auto_capture] && !order.checkout.payments.any? {|p| payment.source.is_a?(PayuIn) && p.source.echeck?(p) }
            order.pay!
          end
        end
    end

  end
end