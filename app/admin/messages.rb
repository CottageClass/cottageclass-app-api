ActiveAdmin.register Message do
  # to edit forms and menus, see: https://activeadmin.info/5-forms.html

  menu priority: 2
  permit_params :content
  index do
    column :id
    column :sender
    column :receiver
    column :content
    column :created_at
    column :updated_at
    column 'link' do |message|
      service_id = ENV['TWILIO_PROXY_SERVICE_SID']
      session_id = message.cc_twilio_session.twilio_sid
      link_to('LINK',
              "https://www.twilio.com/console/proxy/services/#{service_id}/sessions/#{session_id}/interactions",
              target: :_blank)
    end
  end
end
