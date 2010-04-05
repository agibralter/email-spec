# require this in your env.rb file after you require cucumber/rails/world

require 'email_spec_delivery'

# Global Setup
if defined?(ActionMailer)
  Before do
    # Scenario setup
    case ActionMailer::Base.delivery_method
      when :test then ActionMailer::Base.deliveries.clear
      when :cache then ActionMailer::Base.clear_cache
      when :email_spec then ActionMailer::Base.clear_deliveries
    end
  end
end

After do
  EmailSpec::EmailViewer.save_and_open_all_raw_emails if ENV['SHOW_EMAILS']
  EmailSpec::EmailViewer.save_and_open_all_html_emails if ENV['SHOW_HTML_EMAILS']
  EmailSpec::EmailViewer.save_and_open_all_text_emails if ENV['SHOW_TEXT_EMAILS']
end

World(EmailSpec::Helpers)
World(EmailSpec::Matchers)
