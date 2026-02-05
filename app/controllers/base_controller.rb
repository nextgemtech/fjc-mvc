# frozen_string_literal: true

class BaseController < ApplicationController
  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :unauthorized }
      format.html { redirect_to root_path, alert: exception.message }
      format.turbo_stream { render 'errors/unauthorized', status: :unauthorized }
    end
  end

  def current_ability
    @current_ability ||= Ability.new(current_user, guest_session:)
  end

  def guest_session
    @guest_session ||= find_or_create_guest
  end

  def find_or_create_guest
    guest_id = cookies.signed[:guest_session]

    if guest_id.present? && (guest_session = GuestSession.find_by(id: guest_id)).present?
      return guest_session
    end

    guest_session = GuestSession.create(user_agent: request.user_agent)
    cookies.signed.permanent[:guest_session] = guest_session.id

    guest_session
  end
end
