# frozen_string_literal: true

require 'simplecov'

SimpleCov.start do
  add_group 'Actions', 'app/actions'
  add_group 'Controllers', 'app/controllers'
  add_group 'Jobs', 'app/jobs'
  add_group 'Models', 'app/models'
  add_group 'Mailers', 'app/mailers'

  add_filter 'config'
  add_filter 'spec'
  add_filter 'app/channels'
end
