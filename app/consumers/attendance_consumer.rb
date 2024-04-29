# frozen_string_literal: true

class AttendanceConsumer < ApplicationConsumer
  # Consumes the messages by inserting all of them in one go into the DB
  def consume
    messages.payloads.each do |message_payload|
      case message_payload['event']
      when 'sign_in'
        Attendance.create!(message_payload.except('event'))

      when 'sign_out'
        Attendance \
          .where(entity_identifier: message_payload['entity_identifier'], site_identifier: message_payload['site_identifier']) \
          .last \
          .update(sign_out_time: message_payload['sign_out_time'])
      end

    end
  end
end
