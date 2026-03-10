import ColorPickerController from "keystone_ui/color_picker_controller"
import MultiSelectController from "keystone_ui/multi_select_controller"

export function registerControllers(application) {
  application.register("color-picker", ColorPickerController)
  application.register("multi-select", MultiSelectController)
}

export { ColorPickerController, MultiSelectController }
