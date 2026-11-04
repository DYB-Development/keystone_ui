# frozen_string_literal: true

module Keystone
  module Ui
    class SortableListComponent < ViewComponent::Base
      HANDLE_CLASSES = "ks-tone-muted flex size-11 shrink-0 cursor-grab touch-none select-none items-center justify-center"
      ICON_CLASSES = "size-5"
      STATUS_CLASSES = "sr-only"

      erb_template <<~ERB
        <div data-controller="sortable-list">
          <ul aria-label="<%= @label %>">
            <% @rows.each do |row| %>
              <li data-sortable-list-target="row">
                <input type="hidden" name="<%= @name %>" value="<%= row[:id] %>">
                <span hidden data-sortable-list-target="control" class="<%= HANDLE_CLASSES %>" data-action="pointerdown->sortable-list#grab pointermove->sortable-list#drag pointerup->sortable-list#drop pointercancel->sortable-list#drop">
                  <svg class="<%= ICON_CLASSES %>" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" aria-hidden="true">
                    <path stroke-linecap="round" d="M4 8h16M4 16h16" />
                  </svg>
                </span>
                <%= row[:label] %>
                <button hidden data-sortable-list-target="control" type="button" aria-label="Move <%= row[:label] %> up" data-action="sortable-list#moveUp"></button>
                <button hidden data-sortable-list-target="control" type="button" aria-label="Move <%= row[:label] %> down" data-action="sortable-list#moveDown"></button>
              </li>
            <% end %>
          </ul>
          <div role="status" class="<%= STATUS_CLASSES %>" data-sortable-list-target="status"></div>
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
