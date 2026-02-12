# frozen_string_literal: true

class Admin::ErrorsController < Admin::BaseController
  def not_found
    render status: :not_found
  end

  def internal_server_error
    render status: :internal_server_error
  end
end
