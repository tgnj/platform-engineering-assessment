namespace :simulate do
  desc 'Pump attendance data'
  task attendance: :environment do
    sample = Array.new(10) do
      {
        entity_identifier: "PCO:CHILD:#{SecureRandom.uuid}",
        site_identifier: "PCO:SITE:#{SecureRandom.uuid}"
      }
    end

    sign_ins = sample.map { |t| t.merge(sign_in_time: Time.zone.now, event: 'sign_in') }
    sign_ins.each do |sign_in|
      Karafka.producer.produce_async(
        topic: 'attendance',
        payload: sign_in.to_json
      )
    end

    sign_outs = sample.map { |t| t.merge(sign_out_time: Time.zone.now + 1.hour, event: 'sign_out') }
    sign_outs.each do |sign_out|
      Karafka.producer.produce_async(
        topic: 'attendance',
        payload: sign_out.to_json
      )
    end
  end
end
