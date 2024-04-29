# frozen_string_literal: true

# Represents a single page visit
class Visit < ApplicationRecord
  # after_create :update_recent_cache

  scope :recent, -> { includes(:visitor).order(visited_at: :desc).limit(Visit::N_MOST_RECENT_VISITS) }

  belongs_to :visitor

  N_MOST_RECENT_VISITS = 20
  MOST_RECENT_VISITS_CACHE_KEY = 'most_recent_visits'

  def broadcast
    Karafka.producer.produce_async(
      topic: 'visits',
      payload: {
        id: id,
        visited_at: visited_at,
        visitor_id: visitor_id,
        page_path: page_path
      }.to_json
    )
  end

  def self.most_recent_cached
    # This won't work since the page displays the most recent visits is always adding visits

    # Rails.cache.fetch(MOST_RECENT_VISITS_CACHE_KEY, expires_in: 5.minutes) do
      Visit.recent
    # end
  end

  private

  # def update_recent_cache
  #   recent_visits = Visit.most_recent_cached
  #   recent_visits.unshift(self)
  #   recent_visits.pop if recent_visits.length > N_MOST_RECENT_VISITS

  #   Rails.cache.write(MOST_RECENT_VISITS_CACHE_KEY, recent_visits)
  # end
end
