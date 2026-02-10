# frozen_string_literal: true
# typed: true

module ApplicationHelper
  extend T::Sig

  # Concerns
  include Pagy::Frontend

  sig { params(price: T.any(Integer, Float, BigDecimal), unit: String).returns(String) }
  def price_with_currency(price, unit = '')
    T.must(ActionController::Base.helpers
      .number_to_currency(price, precision: 2, strip_insignificant_zeros: true, unit:))
  end

  sig { params(price: T.any(Integer, Float, BigDecimal), qty: Integer).returns(T.any(Integer, Float, BigDecimal)) }
  def total_price_calc(price:, qty: 1)
    price * qty
  end

  def discounted_price(price, discount_percent)
    price - (price * (discount_percent / 100.0))
  end

  def timeago(date, format: :long)
    return if date.blank?

    content = I18n.l(date, format: format)

    tag.time(content,
             title: content,
             data: {
               controller: 'timeago',
               timeago_datetime_value: date.iso8601
             })
  end
end
