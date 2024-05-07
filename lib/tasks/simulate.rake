namespace :simulate do
  desc 'Pump attendance data'
  task attendance: :environment do
    sample = Array.new(10) do
      {
        entity_identifier: "PCO:CHILD:#{SecureRandom.uuid}",
        site_identifier: "PCO:SITE:#{SecureRandom.uuid}"
      }
    end

    sign_ins = sample.map { |t| t.merge(sign_in_time: Time.zone.now) }
    sign_ins.each do |sign_in|
      Karafka.producer.produce_async(
        topic: 'sign_in',
        payload: sign_in.to_json
      )
    end

    sleep 5

    sign_outs = sample.map { |t| t.merge(sign_out_time: Time.zone.now + rand(1..100).minutes) }
    sign_outs.each do |sign_out|
      Karafka.producer.produce_async(
        topic: 'sign_out',
        payload: sign_out.to_json
      )
    end
  end
end
