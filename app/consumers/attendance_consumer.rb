# frozen_string_literal: true

class AttendanceConsumer < ApplicationConsumer
  REQUIRED_KEYS = %w[entity_identifier site_identifier event].freeze
  OPTIONAL_KEYS = %w[sign_in_time sign_out_time].freeze

  def verify_payload(payload)
    return false unless REQUIRED_KEYS.all? { |key| payload.key?(key) }
    return false unless OPTIONAL_KEYS.any? { |key| payload.key?(key) }

    true
  end

  def event_sign_in(payload)
    Attendance.create(payload.slice('entity_identifier', 'site_identifier', 'sign_in_time'))
  end

  def event_sign_out(payload)
    attendance = Attendance.where(entity_identifier: payload['entity_identifier'],
                                  site_identifier: payload['site_identifier'],
                                  sign_out_time: nil).first

    attendance && attendance.update(sign_out_time: payload['sign_out_time'])
  end

  # Consumes the messages by inserting all of them in one go into the DB. We will create this
  def consume
    messages.each do |message|
      payload = message.payload

      next unless verify_payload payload

      send :"event_#{payload['event']}", payload

      mark_as_consumed(message)
    end
  end
end
