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

  def topic_sign_out # rubocop:disable Metrics/MethodLength
    values = []

    messages.each do |message|
      payload = message.payload
      next unless verify_payload(payload)

      values << Arel::Nodes::Grouping.new([Arel::Nodes.build_quoted(payload['entity_identifier']),
                                           Arel::Nodes.build_quoted(payload['site_identifier']),
                                           Arel::Nodes.build_quoted(payload['sign_out_time'])]).to_sql
      mark_as_consumed(message)
    end

    batch_update = <<-SQL
      UPDATE attendances AS att
      SET sign_out_time = c.sign_out_time::TIMESTAMP,
      updated_at = CURRENT_TIMESTAMP
      FROM (VALUES #{values.join(',')} ) AS c(entity_identifier, site_identifier, sign_out_time)
      WHERE c.entity_identifier = att.entity_identifier
      AND c.site_identifier = att.site_identifier
      AND att.sign_out_time IS NULL;
    SQL

    puts batch_update

    ActiveRecord::Base.connection.execute(batch_update)
  end

  # Consumes the messages by inserting all of them in one go into the DB. We will create this
  def consume
    send :"topic_#{topic.name}"
  end
end
