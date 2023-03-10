class RecurrablesController < ApplicationController
  before_action :set_recurrable, only: %i[ show edit update destroy ]

  # GET /recurrables
  def index
    @recurrables = current_user.recurrables
  end

  # GET /recurrables/1
  def show
  end

  # GET /recurrables/new
  def new
    @recurrable = Recurrable.new
    @recurrable.build_tag
    @categories = current_user.categories
  end

  # GET /recurrables/1/edit
  def edit
    @categories = current_user.categories
    @recurrable.build_tag unless @recurrable.tag
  end

  # POST /recurrables
  def create
    @recurrable = Recurrable.new(recurrable_params)
    @recurrable.user = current_user

    if @recurrable.save
      redirect_to recurrable_url(@recurrable), notice: "Recurrable was successfully created."
    else
      @categories = current_user.categories
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /recurrables/1
  def update
    if @recurrable.update(recurrable_params)
      redirect_to recurrable_url(@recurrable), notice: "Recurrable was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /recurrables/1
  def destroy
    @recurrable.destroy
    redirect_to recurrables_url, notice: "Recurrable was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recurrable
      @recurrable = current_user.recurrables.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to recurrables_url, notice: "Recurrable not found."
    end

    # Only allow a list of trusted parameters through.
    def recurrable_params
      params.require(:recurrable).permit(:name, :day_of_month, :amount, :notes, :category_id, tag_attributes: [:id, :name, :_destroy ])
    end
end
