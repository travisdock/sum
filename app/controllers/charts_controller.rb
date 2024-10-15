class ChartsController < ApplicationController
  def index
  end

  def profit_loss
    start_date = params[:start_date] || Date.today.beginning_of_year
    end_date = params[:end_date] || Date.today.end_of_year
    @data = Chart.profit_loss(user_id: current_user.id, start_date:, end_date:)
    render turbo_stream: turbo_stream.replace('content', partial: 'charts/profit_loss')
  end

  def pie_chart
    render turbo_stream: turbo_stream.replace('content', partial: 'charts/pie_chart')
  end
end
