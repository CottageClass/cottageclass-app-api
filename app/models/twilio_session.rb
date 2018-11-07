class TwilioSession < ApplicationRecord
  alias_attribute :unique_name, :friendly_name
  alias_attribute :twilio_sid, :twilio_id
end
