# frozen_string_literal: true

# Represents a single page visit
class Visit < ApplicationRecord
  scope :recent, -> { includes(:visitor).order(visited_at: :desc).limit(20) }

  belongs_to :visitor

  def broadcast
    Karafka.producer.produce_async(
      topic: 'visits',
      payload: {
        id:,
        visited_at:,
        visitor_id:,
        page_path:
      }.to_json
    )
  end
end
