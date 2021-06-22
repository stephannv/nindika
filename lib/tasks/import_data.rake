# frozen_string_literal: true

class DataTasks
  include Rake::DSL

  def initialize
    namespace :admin do
      task import_data: :environment do
        Admin::ImportData.call
      end
    end
  end
end

DataTasks.new
