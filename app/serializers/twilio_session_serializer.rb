class TwilioSessionSerializer < BaseSerializer
  set_key_transform :camel_lower

  attributes :twilio_sid,
    :twilio_sid_sender,
    :twilio_sid_receiver,
    :proxy_identifier_sender,
    :proxy_identifier_receiver,
    :participant_ids
end
