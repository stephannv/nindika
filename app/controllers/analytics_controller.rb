# frozen_string_literal: true

class AnalyticsController < ApplicationController
  def index
    render Analytics::IndexPage.new
  end
end
