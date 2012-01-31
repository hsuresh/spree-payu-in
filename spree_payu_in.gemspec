# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_payu_in'
  s.version     = '0.0.1'
  s.summary     = 'spree_payu_in adds payu.in payment method to spree commerce'
  s.required_ruby_version = '>= 1.8.7'

  s.author            = 'Suresh Harikrishnan'
  s.email             = 'mail@hsuresh.com'

  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '>= 0.70.1'
#  s.add_development_dependency 'rspec-rails'
end