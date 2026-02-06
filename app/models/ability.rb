# frozen_string_literal: true

class Ability
  # Concerns
  include CanCan::Ability

  def initialize(user, guest_session: nil, portal: Portal::STOREFRONT)
    storefront_permission(guest_session, user) if storefront_portal?(portal)
    admin_permission(user) if admin_portal?(portal)
  end

  private

  def storefront_permission(guest_session, user)
    # public
    can :read, Product
    can :info, Variant
    can :variant_dropdown, Cart

    # Guest permission
    guest_permission(guest_session) if user.blank? && guest_session.present?

    return if user.blank?

    can %i[add_to_cart buy_now], Variant

    # Cart
    can(%i[index update destroy count], Cart, user:)
    can(%i[index sync destroy sync_all], Cart, guest_session:) if guest_session.present?
    can(%i[proceed_checkout total bulk_delete], Cart, Cart.checkout_condition.where(user:)) do |cart|
      ((cart.variant.trackable && cart.variant.count_on_hand.positive? && cart.qty <= cart.variant.count_on_hand) ||
        (!cart.variant.trackable || (cart.variant.trackable && cart.variant.backorderable))) &&
        cart.user.present? && cart.user = user
    end

    # Order
    can(:read, Order, user:)
    can(:show_checkout, Order, user:, placed_at: nil, order_status: { name: 'pending' })
    can(%i[read sync], Order, guest_session:) if guest_session.present?
    can(%i[shipping_details payment_method not_placed], Order, user:, placed_at: nil, order_status: { name: 'pending' })
    can(:not_placed, Order, guest_session:, placed_at: nil, order_status: { name: 'pending' }) if guest_session.present?
    can(:cancel, Order, Order.placed_pending.where(user:)) do |order|
      order.order_status.name == 'pending' && order.placed_at.present? && order.user.present? && order.user = user
    end
  end

  def admin_permission(user)
    return unless user&.admin?

    # Product
    can :manage, Product
    can :manage, Variant, is_master: false, product: { has_variant: true }
    can :manage, :image
    can :manage, :dashboard
    can :manage, :stock

    # Order
    can %i[read update_internal_note], Order
    can :destroy, Order, order_status: { name: 'pending' }, placed_at: nil
    can :update_shipping_details, Order, order_status: { name: %w[pending to_ship] }
    can :update_logistic_details, Order, order_status: { name: %w[to_recieve completed refunded returned] }
    can :update_return_reason, Order, order_status: { name: 'returned' }
    can :update_refund_reason, Order, order_status: { name: 'refunded' }
    can :recieve, Order, order_status: { name: 'to_ship' }
    can :refund, Order, order_status: { name: 'completed' }
    can %i[complete return], Order, order_status: { name: 'to_recieve' }
    can %i[cancel ship], Order, Order.placed_pending do |order|
      order.order_status.name == 'pending' && order.placed_at.present?
    end

    can :manage, Category
    can :manage, Option
    can :manage, User
  end

  def guest_permission(guest_session)
    can %i[guest_add_to_cart guest_buy_now], Variant

    # Cart
    can(%i[index update destroy count], Cart, guest_session:)
    can(%i[proceed_checkout total bulk_delete], Cart, Cart.checkout_condition.where(guest_session:)) do |cart|
      ((cart.variant.trackable && cart.variant.count_on_hand.positive? && cart.qty <= cart.variant.count_on_hand) ||
      (!cart.variant.trackable || (cart.variant.trackable && cart.variant.backorderable))) &&
        cart.guest_session.present? && cart.guest_session = guest_session
    end

    # Order
    can(:read, Order, guest_session:)
    can(:show_checkout, Order, guest_session:, placed_at: nil, order_status: { name: 'pending' })
    can(%i[shipping_details payment_method], Order, guest_session:, placed_at: nil, order_status: { name: 'pending' })
    can(:not_placed, Order, guest_session:, placed_at: nil, order_status: { name: 'pending' })
    can(:cancel, Order, Order.placed_pending.where(guest_session:)) do |order|
      order.order_status.name == 'pending' && order.placed_at.present? && order.guest_session.present? &&
        order.guest_session = guest_session
    end
  end

  def storefront_portal?(portal)
    portal == Portal::STOREFRONT
  end

  def admin_portal?(portal)
    portal == Portal::ADMIN
  end
end
