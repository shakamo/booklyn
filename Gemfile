source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.2.0'
# Use sqlite3 as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc',         group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

gem 'nokogiri'

group :test do
  # 必須
  gem 'minitest'
  gem 'minitest-rails'
  gem 'minitest-rails-capybara' # capybaraで結合テストできるようにする

  gem 'minitest-doc_reporter' # テスト結果の表示を整形

  # 機能追加系
  # gem "minitest-stub_any_instance" # メソッドmockを追加できる様にする

  # gem "minitest-bang" # let文で遅延読み込みを使えるようにする
  # gem "minitest-line" # 行番号指定でテスト実行出来る様にする

  gem 'factory_girl' # DBのデータのモックを作成

  gem 'rubocop'
end

gem 'chronic'

gem 'rails_12factor', group: :production

gem 'dalli'

gem 'delayed_job_active_record'

gem 'aasm'

gem 'rubocop', require: false

ruby '2.2.2'
