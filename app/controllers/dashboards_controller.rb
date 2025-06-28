class DashboardsController < ApplicationController
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
end
