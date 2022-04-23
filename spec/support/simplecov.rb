# frozen_string_literal: true

require 'simplecov'

SimpleCov.start do
  add_group 'Clients', 'app/clients'
  add_group 'Components', 'app/components'
  add_group 'Controllers', 'app/controllers'
  add_group 'Data Adapters', 'app/data_adapters'
  add_group 'Enumerations', 'app/enumerations'
  add_group 'Form Objects', 'app/form_objects'
  add_group 'Jobs', 'app/jobs'
  add_group 'Lib', 'app/lib'
  add_group 'Models', 'app/models'
  add_group 'Mailers', 'app/mailers'
  add_group 'Operations', 'app/operations'
  add_group 'Queries', 'app/queries'

  add_filter 'config'
  add_filter 'spec'
  add_filter 'app/channels'
end
