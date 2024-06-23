require 'csv'

class EntriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_entry, only: %i[ show edit update destroy ]

  # GET /entries or /entries.json
  def index
    set_session_filters if params['commit'] == 'Filter'
    set_session_ordering if params['q'].present?
    set_entries

    @years = current_user.entries.pluck(Arel.sql("DISTINCT strftime('%Y', date)")).sort.map(&:to_i)
    @categories = current_user.categories
    @tags = current_user.tags
  end

  # GET /entries/1 or /entries/1.json
  def show
  end

  # GET /entries/new
  def new
    @entry = Entry.new
    @entry.build_tag
    @categories = current_user.categories
  end

  # GET /entries/1/edit
  def edit
    @categories = current_user.categories
    @entry.build_tag unless @entry.tag
  end

  # POST /entries
  def create
    @entry = Entry.new(entry_params)
    @entry.user = current_user

    if @entry.save
      redirect_to new_entry_url, notice: "Entry was successfully created."
    else
      @categories = current_user.categories
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /entries/1
  def update
    if @entry.update(entry_params)
      redirect_to entry_url(@entry), notice: "Entry was successfully updated."
    else
      @categories = current_user.categories
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /entries/1
  def destroy
    @entry.destroy
    redirect_to entries_url, notice: "Entry was successfully destroyed."
  end

  # GET /entries/export
  def export
    @entries = current_user.entries
    respond_to do |format|
      format.csv do
        response.headers['Content-Type'] = 'text/csv'
        response.headers['Content-Disposition'] = "attachment; filename=entries.csv"
        render 'export'
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_entry
      @entry = current_user.entries.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to entries_url, notice: "Entry not found."
    end

    # Only allow a list of trusted parameters through.
    def entry_params
      params.require(:entry).permit(:date, :amount, :notes, :category_name, :income, :untracked, :user_id, :category_id, tag_attributes: [:id, :name, :_destroy])
    end

    def search_params
      params.fetch(:q, {}).permit(:notes_or_amount_cont, :s)
    end

    def set_session_filters
      session[:entry_filter_category_id] = params['category_id']
      session[:entry_filter_tag_id] = params['tag_id']
      session[:entry_filter_year] = params['year']
      session[:entry_filter_month] = params['month']
      session[:entry_filter_income] = params['income']
    end

    def set_session_ordering
      session[:sorting] = search_params['s']
    end

    def set_entries
      @entries = current_user
                 .entries
                 .by_year(session[:entry_filter_year] || Date.today.year)
                 .by_month(session[:entry_filter_month] || Date.today.month)
                 .by_income(ActiveModel::Type::Boolean.new.cast(session[:entry_filter_income]))
                 .by_category_id(session[:entry_filter_category_id])
                 .by_tag_id(session[:entry_filter_tag_id])
                 .includes(:category)

    @q = @entries.ransack(search_params.empty? ? { s: session[:sorting] } : search_params)
    @entries = @q.result(distinct: true)
    end
end
