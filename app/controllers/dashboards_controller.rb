class DashboardsController < ApplicationController
  before_action :authenticate_user!

  # GET POST /dashboard
  def show
    entries = current_user.entries.by_year(params['year'] || Date.today.year).by_month(params['month'] || Date.today.month)
    @data = Dashboard.new(entries)
    @years = current_user.entries.order(:date).pluck(:date).uniq { |d| d.year }.map(&:year)

    respond_to do |format|
      format.html
      format.turbo_stream { render turbo_stream: turbo_stream.replace(:data, partial: "data", locals: { data: @data }) }
    end
  end

  def charts
    entries = current_user.entries.by_income(false).by_year(params['year']).by_month(params['month'])
    @data = Dashboard.new(entries)
    render turbo_stream: turbo_stream.replace(:chart, partial: params[:chart_name], locals: { data: @data })
  end
end
