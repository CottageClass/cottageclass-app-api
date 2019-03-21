class TwilioSessionSerializer < BaseSerializer
  set_key_transform :camel_lower

  attributes :twilio_sid,
             :twilio_sid_initiator,
             :twilio_sid_client,
             :proxy_identifier_initiator,
             :proxy_identifier_client,
             :initiator_id,
             :client_id
end
