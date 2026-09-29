# frozen_string_literal: true

require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"].exclude("test/render/**/*_test.rb")
end

Rake::TestTask.new("test:render") do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/render/**/*_test.rb"]
end

task default: [ :test, "test:render" ]

require "the_local/rake"
