# frozen_string_literal: true

module Keystone
  module Ui
    class SortableListComponent < ViewComponent::Base
      erb_template <<~ERB
        <div data-controller="sortable-list">
          <ul aria-label="<%= @label %>">
            <% @rows.each do |row| %>
              <li data-sortable-list-target="row">
                <input type="hidden" name="<%= @name %>" value="<%= row[:id] %>">
                <%= row[:label] %>
              </li>
            <% end %>
          </ul>
        </div>
      ERB

      def initialize(name:, label:, rows:)
        @name = name
        @label = label
        @rows = rows
      end
    end
  end
end
