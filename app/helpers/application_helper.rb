module ApplicationHelper
  FLASH_NAME = {  success: 'alert-success', notice: 'alert-success',
                  error: 'alert-danger', alert: 'alert-danger' }.freeze

  def bootstrap_class_for_flash(flash_type)
    flash = FLASH_NAME[flash_type.to_sym] || flash_type.to_s
  end
end
