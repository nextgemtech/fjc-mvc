# frozen_string_literal: true

class Admin::DashboardController < Admin::BaseController
  authorize_resource class: false

  def index
    @completed_orders = Order.where(order_status: { name: 'completed' })
                             .joins(:order_status).count

    @completed_orders_prev_percent = 0.0

    @chart_data = {
      labels: %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday],
      datasets: [{
        label: 'Completed Orders',
        backgroundColor: 'transparent',
        borderColor: '#3B82F6',
        data: [37, 83, 78, 54, 12, 5, 1000]
      }]
    }

    @chart_options = {}

    @chart_config = {
      type: 'line',
      data: @chart_data,
      options: @chart_options
    }
  end
end
