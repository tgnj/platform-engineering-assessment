# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AttendanceConsumer do
  subject(:consumer) { karafka.consumer_for(:attendance) }
  let(:visitor_id) { SecureRandom.uuid }
  let(:attendances) do
    Array.new(2) do
      {
        id: SecureRandom.uuid,
        visited_at: Time.zone.now,
        visitor_id: visitor_id,
        page_path: '/'
      }
    end
  end

  # Publish two visits of one user
  before { attendances.each { |attendance| karafka.produce(attendance.to_json) } }

  it 'expects to save the attendance' do
    expect { consumer.consume }.to change(Attendance, :count).by(attendances.count)
  end
end
