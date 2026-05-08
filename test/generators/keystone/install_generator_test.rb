# frozen_string_literal: true

require "test_helper"

unless defined?(Rails)
  module Rails
    module Generators
      class Base
        def self.desc(description = nil)
          @desc = description if description
          @desc
        end

        def self.source_root(path = nil)
          @source_root = path if path
          @source_root
        end
      end
    end
  end
end

require_relative "../../../lib/generators/keystone/install_generator"

class Keystone::InstallGeneratorTest < Minitest::Test
  def test_inherits_from_rails_generators_base
    assert_equal Rails::Generators::Base, Keystone::InstallGenerator.superclass
  end

  def test_has_a_setup_tailwind_method
    assert_includes Keystone::InstallGenerator.instance_methods, :setup_tailwind
  end

  def test_uses_an_import_for_keystone_source_css
    assert_equal '@import "./keystone_source.css";', Keystone::InstallGenerator::KEYSTONE_IMPORT
  end

  def test_does_not_inject_local_gem_paths
    source = File.read(File.expand_path("../../../lib/generators/keystone/install_generator.rb", __dir__))
    refute_includes source, "Engine.root"
  end

  def test_anchors_injection_after_import_tailwindcss
    assert_equal '@import "tailwindcss";', Keystone::InstallGenerator::TAILWIND_IMPORT
  end

  def test_has_a_generate_claude_docs_method
    assert_includes Keystone::InstallGenerator.instance_methods, :generate_claude_docs
  end
end
