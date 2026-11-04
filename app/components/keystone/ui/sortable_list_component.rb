# frozen_string_literal: true

module Keystone
  module Ui
    class SortableListComponent < ViewComponent::Base
      ROW_CLASSES = "ks-value-list-row items-center data-dragging:opacity-50"
      LABEL_CLASSES = "ks-paragraph min-w-0 flex-1"
      HANDLE_CLASSES = "ks-tone-muted flex size-11 shrink-0 cursor-grab touch-none select-none items-center justify-center"
      MOVE_BUTTON_CLASSES = "ks-button ks-button-secondary ks-button-sm size-11 shrink-0"
      ICON_CLASSES = "size-5"
      STATUS_CLASSES = "sr-only"

      erb_template <<~ERB
        <div data-controller="sortable-list">
          <ul aria-label="<%= @label %>">
            <% @rows.each do |row| %>
              <li class="<%= ROW_CLASSES %>" data-sortable-list-target="row">
                <input type="hidden" name="<%= @name %>" value="<%= row[:id] %>">
                <span hidden data-sortable-list-target="control" class="<%= HANDLE_CLASSES %>" data-action="pointerdown->sortable-list#grab pointermove->sortable-list#drag pointerup->sortable-list#drop pointercancel->sortable-list#drop">
                  <svg class="<%= ICON_CLASSES %>" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" aria-hidden="true">
                    <path stroke-linecap="round" d="M4 8h16M4 16h16" />
                  </svg>
                </span>
                <span class="<%= LABEL_CLASSES %>"><%= row[:label] %></span>
                <button hidden data-sortable-list-target="control" type="button" class="<%= MOVE_BUTTON_CLASSES %>" aria-label="Move <%= row[:label] %> up" data-action="sortable-list#moveUp">
                  <svg class="<%= ICON_CLASSES %>" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" aria-hidden="true">
                    <path stroke-linecap="round" stroke-linejoin="round" d="m4.5 15.75 7.5-7.5 7.5 7.5" />
                  </svg>
                </button>
                <button hidden data-sortable-list-target="control" type="button" class="<%= MOVE_BUTTON_CLASSES %>" aria-label="Move <%= row[:label] %> down" data-action="sortable-list#moveDown">
                  <svg class="<%= ICON_CLASSES %>" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" aria-hidden="true">
                    <path stroke-linecap="round" stroke-linejoin="round" d="m19.5 8.25-7.5 7.5-7.5-7.5" />
                  </svg>
                </button>
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
