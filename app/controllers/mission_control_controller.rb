class MissionControlController < ApplicationController
  before_action :ensure_admin

  http_basic_authenticate_with(
    name: "admin",
    password: "admin"
  )

  def ensure_admin
    Rails.logger.error "#{current_user.inspect}"
    current_user.id == '1'
  end
end
