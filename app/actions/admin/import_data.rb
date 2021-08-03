# frozen_string_literal: true

module Admin
  class ImportData < Actor
    def call
      wrap_task('Import items') { RawItems::Import.call }
      wrap_task('Import prices') { Prices::Import.call }
      wrap_task('Update flags') { Items::UpdateFlags.call }
    end

    private

    def wrap_task(task_name)
      yield
    rescue StandardError => e
      raise e if Rails.env.development?

      Sentry.capture_exception(e, extra: { task: task_name })
    end
  end
end
