# frozen_string_literal: true

require 'simplecov'

SimpleCov.start do
  add_group 'Actions', 'app/actions'
  add_group 'Clients', 'app/clients'
  add_group 'Controllers', 'app/controllers'
  add_group 'Data Adapters', 'app/data_adapters'
  add_group 'Enumerations', 'app/enumerations'
  add_group 'Jobs', 'app/jobs'
  add_group 'Models', 'app/models'
  add_group 'Mailers', 'app/mailers'

  add_filter 'config'
  add_filter 'spec'
  add_filter 'app/channels'
end
