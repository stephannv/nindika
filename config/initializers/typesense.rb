
config = YAML.load(ERB.new(File.read Rails.root.join('config/typesense.yml')).result)
environment_config = config[Rails.env]
environment_config.merge!(
  'logger' => Logger.new($stdout),
  'log_level' => Logger::INFO
) if Rails.env.development?
TypesenseConnection = environment_config.deep_symbolize_keys.freeze
