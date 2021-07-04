# frozen_string_literal: true

module Admin
  class ImportData < Actor
    def call
      Task.start 'Import items' do
        RawItems::Import.call
      end

      Task.start 'Import prices' do
        Prices::Import.call
      end
    end
  end
end
