import ColorPickerController from "keystone_ui/color_picker_controller"
import MultiSelectController from "keystone_ui/multi_select_controller"
import SwipeDeckController from "keystone_ui/swipe_deck_controller"
import ColumnPickerController from "keystone_ui/column_picker_controller"
import FileUploadController from "keystone_ui/file_upload_controller"

export function registerControllers(application) {
  application.register("color-picker", ColorPickerController)
  application.register("multi-select", MultiSelectController)
  application.register("swipe-deck", SwipeDeckController)
  application.register("column-picker", ColumnPickerController)
  application.register("file-upload", FileUploadController)
}

export { ColorPickerController, MultiSelectController, SwipeDeckController, ColumnPickerController, FileUploadController }
