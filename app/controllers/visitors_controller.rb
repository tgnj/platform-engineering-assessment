# frozen_string_literal: true

# Visitors display controller
class VisitorsController < ApplicationController
  # Lists most recent visitors
  def index
    @visitors = Visitor.page(params[:page]).order(created_at: :desc)
  end

  # Shows visitor details
  def show
    @visitor = Visitor.find(params[:id])
    @visits = @visitor.visits.order(visited_at: :desc).limit(50)
  end
end
