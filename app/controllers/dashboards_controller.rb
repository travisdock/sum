class DashboardsController < ApplicationController
  before_action :authenticate_user!

  # GET POST /dashboard
  def show
    entries = Entry.where(user: current_user).by_year(params['year'] || current_user.year_view).by_month(params['month'])
    @years = Entry.where(user: current_user).pluck(:date).uniq { |d| d.year }.map(&:year)
    @data = Dashboard.new(entries)

    respond_to do |format|
      format.html
      format.turbo_stream { render turbo_stream: turbo_stream.replace(:data, partial: "data", locals: { data: @data }) }
    end
  end
end
