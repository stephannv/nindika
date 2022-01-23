# frozen_string_literal: true

task before_assets_precompile: :environment do
  Rake::Task['webpacker:yarn_install'].invoke
end

Rake::Task['assets:precompile'].enhance ['before_assets_precompile'] do
  Rake::Task['webpacker:compile'].invoke
end
