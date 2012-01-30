require 'spree_core'

module SpreePayuIn
  class Engine < Rails::Engine
    engine_name 'spree_payu_in'

    config.autoload_paths += %W(#{config.root}/lib)

    def self.activate
      # Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*.rb")) do |c|
      #   Rails.application.config.cache_classes ? require(c) : load(c)
      # end
      CheckoutController.class_eval do
        include Spree::PayuIn
      end
    end

    initializer "spree.register.payment_methods" do |app|
      app.config.spree.payment_methods << Gateway::PayuIn
    end

    config.to_prepare &method(:activate).to_proc
  end
end
