# frozen_string_literal: true

# Represents a single website visitor
class Visitor < ApplicationRecord
  self.per_page = 50

  has_many :visits
end
