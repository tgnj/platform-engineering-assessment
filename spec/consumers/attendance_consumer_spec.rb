# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AttendanceConsumer do
  subject(:consumer) { karafka.consumer_for(:attendance) }

  let(:samples) do
    Array.new(4) do
      {
        entity_identifier: "PCO:CHILD:#{SecureRandom.uuid}",
        site_identifier: "PCO:SITE:#{SecureRandom.uuid}"
      }
    end
  end

  describe 'event sign_in' do
    let(:sign_ins) do
      samples.map { |t| t.merge(sign_in_time: Time.zone.now, event: 'sign_in') }
    end

    it 'works' do
      sign_ins.each { |sign_in| karafka.produce(sign_in.to_json) }
      expect { consumer.consume }.to change(Attendance, :count).by(sign_ins.count)
    end
  end

  describe 'event sign_out' do
    let(:sign_outs) do
      samples.map { |t| t.merge(sign_out_time: Time.zone.now, event: 'sign_out') }
    end

    before do
      sign_ins = samples.map { |t| t.merge(sign_in_time: Time.zone.now) }
      sign_ins.each { |sign_in| Attendance.create(sign_in) }
    end

    it 'expects to update the attendance' do
      Attendance.destroy_all

      sign_outs.each { |sign_out| karafka.produce(sign_out.to_json) }
      expect { consumer.consume }.not_to change(Attendance, :count)
    end
  end
end
