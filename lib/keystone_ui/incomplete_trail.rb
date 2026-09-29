# frozen_string_literal: true

module KeystoneUi
  class IncompleteTrail < StandardError
    def initialize(title)
      super(%(The page "#{title}" has a breadcrumb trail with a link that has no label or no address. Give every link in the trail both.))
    end
  end
end
