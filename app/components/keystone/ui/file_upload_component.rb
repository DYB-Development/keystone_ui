# frozen_string_literal: true

module Keystone
  module Ui
    class FileUploadComponent < ViewComponent::Base
      WRAPPER_CLASSES = "space-y-1"
      LABEL_CLASSES = "block text-sm font-medium text-gray-700 dark:text-gray-300"
      DROP_ZONE_CLASSES = "mt-1 flex justify-center rounded-md border-2 border-dashed border-gray-300 px-6 py-8 dark:border-zinc-600"
      DROP_ZONE_INNER_CLASSES = "space-y-2 text-center"
      ICON_CLASSES = "mx-auto h-10 w-10 text-gray-400 dark:text-gray-500"
      BUTTON_CLASSES = "text-sm font-semibold text-accent-600 hover:text-accent-500 dark:text-accent-400 dark:hover:text-accent-300 cursor-pointer"
      HINT_CLASSES = "mt-1 text-xs text-gray-500 dark:text-gray-400"
      FILE_INPUT_CLASSES = "sr-only"

      UPLOAD_ICON = <<~SVG.freeze
        <svg class="#{ICON_CLASSES}" stroke="currentColor" fill="none" viewBox="0 0 48 48" aria-hidden="true">
          <path d="M28 8H12a4 4 0 00-4 4v20m32-12v8m0 0v8a4 4 0 01-4 4H12a4 4 0 01-4-4v-4m32-4l-3.172-3.172a4 4 0 00-5.656 0L28 28M8 32l9.172-9.172a4 4 0 015.656 0L28 28m0 0l4 4m4-24h8m-4-4v8m-12 4h.02" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
        </svg>
      SVG

      def initialize(name:, label: nil, accept: nil, multiple: false, hint: nil)
        @name = name
        @label = label
        @accept = accept
        @multiple = multiple
        @hint = hint
      end

      def input_name
        @name
      end

      def label_text
        @label || "Choose file"
      end

      def accept
        @accept
      end

      def multiple?
        @multiple
      end

      def hint?
        !@hint.nil?
      end

      def hint_text
        @hint
      end

      def wrapper_data
        { controller: "file-upload" }
      end

      def drop_zone_data
        { "file-upload-target": "dropZone" }
      end

      def tag_options
        options = {
          type: "file",
          name: @name,
          class: FILE_INPUT_CLASSES
        }
        options[:accept] = @accept if @accept
        options[:multiple] = true if @multiple
        options
      end
    end
  end
end
