import ColorPickerController from "keystone_ui/color_picker_controller"

export function registerControllers(application) {
  application.register("color-picker", ColorPickerController)
}

export { ColorPickerController }
