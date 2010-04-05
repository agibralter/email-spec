require 'fileutils'

module EmailSpec
  module EmailSpecDelivery

    DELIVERIES_PATH = File.join(Rails.root, 'tmp', 'email_spec_deliveries.cache')

    def self.included(base)
      base.instance_eval do
        alias :orig_deliveries :deliveries
      end

      base.class_eval do
        def self.deliveries
          if ActionMailer::Base.delivery_method == :email_spec
            File.exist?(DELIVERIES_PATH) ? File.open(DELIVERIES_PATH, 'r') { |f| Marshal.load(f) } : []
          else
            self.orig_deliveries
          end
        end

        def self.clear_deliveries
          FileUtils.rm_f(DELIVERIES_PATH) if File.exist?(DELIVERIES_PATH)
        end
      end
    end

    def perform_delivery_email_spec(mail)
      deliveries = self.class.deliveries << mail
      File.open(DELIVERIES_PATH, 'w') do |f|
        f << Marshal.dump(deliveries)
      end
    end
  end
end

ActionMailer::Base.send(:include, EmailSpec::EmailSpecDelivery)
