# frozen_string_literal: true

class AttendanceConsumer < ApplicationConsumer # rubocop:disable Style/Documentation
  REQUIRED_KEYS = %w[entity_identifier site_identifier].freeze
  OPTIONAL_KEYS = %w[sign_in_time sign_out_time].freeze

  def verify_payload(payload)
    return false unless REQUIRED_KEYS.all? { |key| payload.key?(key) }
    return false unless OPTIONAL_KEYS.any? { |key| payload.key?(key) }

    true
  end

  def topic_sign_in
    payloads = []

    messages.each do |message|
      payload = message.payload
      next unless verify_payload(payload)

      mark_as_consumed(message)
      payloads << payload.slice('entity_identifier', 'site_identifier', 'sign_in_time')
    end

    ::Attendance.insert_all(payloads)
  end

  def topic_sign_out
    messages.each do |message|
      payload = message.payload
      next unless verify_payload(payload)

      attendance = Attendance.where(entity_identifier: payload['entity_identifier'],
                                    site_identifier: payload['site_identifier'],
                                    sign_out_time: nil).first

      mark_as_consumed(message) if attendance&.update(sign_out_time: payload['sign_out_time'])
    end
  end

  # Consumes the messages by inserting all of them in one go into the DB. We will create this
  def consume
    send :"topic_#{topic.name}"
  end
end
