API_KEY = 'your_secret_api_key_here'
LIST_ID = 'your_mailing_list_id_here'  # Get this from the "change type" page for the list
WEBHOOK_URL = 'http://example.com/path/to/your_webhook.json'

def campaign_monitor_list
  CreateSend::List.new({:api_key => API_KEY}, LIST_ID)
end

# NOTE: That I depend on :environment for all of these. That is to load the
#       Rails environment I use them in. You can change that and require 'createsend'
#       explicitly if you like.
namespace :campaign_monitor do
  namespace :webhooks do
    desc "List all the CampaignMonitor webhooks"
    task :list => :environment do
      puts campaign_monitor_list.webhooks.inspect
    end

    desc "Register all our CampaignMonitor webhooks"
    task :create => :environment do
      campaign_monitor_list.create_webhook(
        ["Subscribe", "Deactivate"],
        WEBHOOK_URL,
        'json'
      )
    end

    desc "Test all our CampaignMonitor webhooks"
    task :test => :environment do
      list = campaign_monitor_list
      list.webhooks.each do |hook|
        list.test_webhook(hook[:WebhookID])
      end
    end

    desc "Uninstall all our CampaignMonitor webhooks"
    task :clear => :environment do
      list = campaign_monitor_list
      list.webhooks.each do |hook|
        list.delete_webhook(hook[:WebhookID])
      end
    end
  end
end
