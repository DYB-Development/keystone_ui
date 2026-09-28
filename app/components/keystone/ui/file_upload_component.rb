# frozen_string_literal: true

module Keystone
  module Ui
    class FileUploadComponent < ViewComponent::Base
      WRAPPER_CLASSES = "ks-file-upload"
      LABEL_CLASSES = "ks-label block text-sm"
      DROP_ZONE_CLASSES = "ks-file-upload-drop-zone flex justify-center cursor-pointer transition-colors"
      DROP_ZONE_ACTIVE_CLASSES = "ks-file-upload-drop-zone-active"
      DROP_ZONE_INNER_CLASSES = "ks-file-upload-inner text-center"
      ICON_CLASSES = "ks-file-upload-icon mx-auto h-10 w-10"
      PROMPT_CLASSES = "ks-file-upload-prompt text-sm"
      BROWSE_CLASSES = "ks-file-upload-browse"
      HINT_CLASSES = "mt-1 text-xs text-gray-500 dark:text-gray-400"
      FILE_NAME_CLASSES = "mt-2 text-sm text-gray-700 dark:text-gray-300 truncate"
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

      def prompt_text
        multiple? ? "Drop files here or" : "Drop file here or"
      end

      def wrapper_data
        { controller: "file-upload" }
      end

      def drop_zone_data
        { "file-upload-target": "dropZone" }
      end

      def input_data
        { "file-upload-target": "input", action: "change->file-upload#select" }
      end

      def tag_options
        options = {
          type: "file",
          name: @name,
          class: FILE_INPUT_CLASSES,
          data: { "file-upload-target": "input", action: "change->file-upload#select" }
        }
        options[:accept] = @accept if @accept
        options[:multiple] = true if @multiple
        options
      end
    end
  end
end
