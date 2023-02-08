class DashboardsController < ApplicationController
  before_action :authenticate_user!

  # GET POST /dashboard
  def show
    last_entry_date = Entry.where(user: current_user).order(:date).last.date
    entries = Entry.where(user: current_user).by_year(params['year'] || Date.today.year).by_month(params['month'] || Date.today.month)
    @data = Dashboard.new(entries)
    @years = Entry.where(user: current_user).order(:date).pluck(:date).uniq { |d| d.year }.map(&:year)

    respond_to do |format|
      format.html
      format.turbo_stream { render turbo_stream: turbo_stream.replace(:data, partial: "data", locals: { data: @data }) }
    end
  end

  def charts
    entries = Entry.where(user: current_user).by_income(false).by_year(params['year']).by_month(params['month'])
    @data = Dashboard.new(entries)
    render turbo_stream: turbo_stream.replace(:chart, partial: params[:chart_name], locals: { data: @data })
  end
end
