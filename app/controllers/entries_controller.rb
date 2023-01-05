require 'csv'

class EntriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_entry, only: %i[ show edit update destroy ]

  # GET /entries or /entries.json
  def index
    @entries = Entry.where(user: current_user).by_year(params['year'] || current_user.year_view).includes(:category)
    @years = Entry.where(user: current_user).pluck(:date).uniq { |d| d.year }.map(&:year)
  end

  # POST /filtered_entries
  def filtered_index
    @entries = Entry.where(user: current_user).by_year(params['year'] || current_user.year_view).by_month(params['month'])

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace(:entries, partial: "entries", locals: { entries: @entries }) }
    end
  end

  # GET /entries/1 or /entries/1.json
  def show
  end

  # GET /entries/new
  def new
    @entry = Entry.new
    @categories = current_user.categories.where(year: current_user.year_view)
  end

  # GET /entries/1/edit
  def edit
    @categories = current_user.categories.where(year: current_user.year_view)
  end

  # POST /entries or /entries.json
  def create
    @entry = Entry.new(entry_params)
    @entry.user = current_user

    respond_to do |format|
      if @entry.save
        format.html { redirect_to new_entry_url, notice: "Entry was successfully created." }
        format.json { render :show, status: :created, location: @entry }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /entries/1 or /entries/1.json
  def update
    respond_to do |format|
      if @entry.update(entry_params)
        format.html { redirect_to entry_url(@entry), notice: "Entry was successfully updated." }
        format.json { render :show, status: :ok, location: @entry }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /entries/1 or /entries/1.json
  def destroy
    @entry.destroy

    respond_to do |format|
      format.html { redirect_to entries_url, notice: "Entry was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # GET /entries/export
  def export
    @entries = Entry.where(user: current_user)
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
      @entry = Entry.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def entry_params
      params.require(:entry).permit(:date, :amount, :notes, :category_name, :income, :untracked, :user_id, :category_id)
    end
end
