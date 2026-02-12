# frozen_string_literal: true

class Admin::BaseController < ApplicationController
  layout 'admin'

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :unauthorized }
      format.html { redirect_to current_user&.admin? ? admin_path : root_path, alert: exception.message }
      format.turbo_stream { render 'errors/unauthorized', status: :unauthorized }
    end
  end

  def current_ability
    @current_ability ||= Ability.new(current_user, portal: Portal::ADMIN)
  end
end
