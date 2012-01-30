map.resources :orders do |order|
  order.resource :checkout, :member => {:payu_in_checkout => :any, :payu_in_payment => :any, :payu_in_confirm => :any, :payu_in_finish => :any}
end

map.payu_in_notify "/payu_in_notify", :controller => :payu_in_callbacks, :action => :notify, :method => [:post, :get]

map.namespace :admin do |admin|
  admin.resources :orders do |order|
    order.resources :payu_in_payments, :member => {:capture => :get, :refund => :any}, :has_many => [:txns]
  end
end