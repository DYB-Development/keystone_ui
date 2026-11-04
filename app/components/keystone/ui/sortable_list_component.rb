# frozen_string_literal: true

module Keystone
  module Ui
    class SortableListComponent < ViewComponent::Base
      erb_template <<~ERB
        <ul aria-label="<%= @label %>">
          <% @rows.each do |row| %>
            <li><%= row[:label] %></li>
          <% end %>
        </ul>
      ERB

      def initialize(name:, label:, rows:)
        @name = name
        @label = label
        @rows = rows
      end
    end
  end
end
