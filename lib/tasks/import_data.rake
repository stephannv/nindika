# frozen_string_literal: true

class DataTasks
  include Rake::DSL

  def initialize
    namespace :admin do
      task import_data: :environment do
        Admin::ImportData.call
      end

      task scrap_pending_items_data: :environment do
        Items::ScrapPendingItemsData.call
      end

      task update_games_visits: :environment do
        Items::UpdateVisits.call
      end
    end
  end
end

DataTasks.new
