import ColorPickerController from "keystone_ui/color_picker_controller"
import MultiSelectController from "keystone_ui/multi_select_controller"
import SwipeDeckController from "keystone_ui/swipe_deck_controller"
import ColumnPickerController from "keystone_ui/column_picker_controller"
import FileUploadController from "keystone_ui/file_upload_controller"
import DropdownController from "keystone_ui/dropdown_controller"
import DismissController from "keystone_ui/dismiss_controller"
import ModalController from "keystone_ui/modal_controller"
import ClipboardController from "keystone_ui/clipboard_controller"

export function registerControllers(application) {
  application.register("color-picker", ColorPickerController)
  application.register("multi-select", MultiSelectController)
  application.register("swipe-deck", SwipeDeckController)
  application.register("column-picker", ColumnPickerController)
  application.register("file-upload", FileUploadController)
  application.register("dropdown", DropdownController)
  application.register("dismiss", DismissController)
  application.register("modal", ModalController)
  application.register("clipboard", ClipboardController)
}

export { ColorPickerController, MultiSelectController, SwipeDeckController, ColumnPickerController, FileUploadController, DropdownController, DismissController, ModalController, ClipboardController }
