# frozen_string_literal: true

require 'simplecov'

SimpleCov.start do
  add_group 'Actions', 'app/actions'
  add_group 'API', 'app/api'
  add_group 'Clients', 'app/clients'
  add_group 'Data Adapters', 'app/data_adapters'
  add_group 'Entities', 'app/entities'
  add_group 'Enumerations', 'app/enumerations'
  add_group 'Form Objects', 'app/form_objects'
  add_group 'Jobs', 'app/jobs'
  add_group 'Lib', 'app/lib'
  add_group 'Models', 'app/models'
  add_group 'Mailers', 'app/mailers'
  add_group 'Queries', 'app/queries'
  add_group 'Scrapers', 'app/scrapers'

  add_filter 'config'
  add_filter 'spec'
  add_filter 'app/channels'
end
