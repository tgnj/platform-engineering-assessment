# frozen_string_literal: true

yesterday = Time.current.yesterday.beginning_of_day
10.times do |_i|
  Attendance.create!(
    site_identifier: "PCO:SITE:#{SecureRandom.uuid}",
    entity_identifier: "PCO:CHILD:#{SecureRandom.uuid}",
    sign_in_time: yesterday + 8.hours,
    sign_out_time: yesterday + 12.hours
  )
end
