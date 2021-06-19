class EnablePgExtensions < ActiveRecord::Migration[6.1]
  def change
    enable_extension 'pgcrypto'
    enable_extension 'unaccent'
    enable_extension 'citext'
  end
end
