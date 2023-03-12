class CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_category, only: %i[ show edit update remove destroy ]

  # GET /categories or /categories.json
  def index
    @categories = current_user.categories
  end

  # GET /categories/1 or /categories/1.json
  def show
  end

  # GET /categories/new
  def new
    @category = Category.new
  end

  # GET /categories/1/edit
  def edit
  end

  # POST /categories or /categories.json
  def create
    @category = Category.new(category_params)

    respond_to do |format|
      if @category.save
        current_user.categories << @category
        format.html { redirect_to category_url(@category), notice: "Category was successfully created." }
        format.json { render :show, status: :created, location: @category }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categories/1 or /categories/1.json
  def update
    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to category_url(@category), notice: "Category was successfully updated." }
        format.json { render :show, status: :ok, location: @category }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1/remove
  def remove
    current_user.categories.delete(@category)

    redirect_to categories_url, notice: "Category was successfully removed."
  end

  # DELETE /categories/1 or /categories/1.json
  def destroy
    @category.destroy

    respond_to do |format|
      format.html { redirect_to categories_url, notice: "Category was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # GET /categories/merge
  def merge_form
    @categories = current_user.categories.order(created_at: :asc)
    @tags = current_user.tags
  end

  # POST /categories/merge
  # Copy all entries from one category to another and remove the old category
  def merge
    @old_category = current_user.categories.find(merge_params[:id])
    @merge_with = current_user.categories.find(merge_params[:merge_with])
    if merge_params[:tag_id].present?
      @tag = current_user.tags.find(merge_params[:tag_id])
    elsif merge_params[:tag_name].present?
      @tag = current_user.tags.find_or_create_by(name: merge_params[:tag_name])
    end
    ActiveRecord::Base.transaction do
      entries = Entry.where(category: @old_category)
      entries.update_all(category_id: @merge_with.id, tag_id: @tag&.id)
      @old_category.destroy
    end
    redirect_to merge_categories_path, notice: "Category was successfully merged."

  rescue ActiveRecord::RecordInvalid => e
    redirect_to merge_categories_path, alert: "There was an error. Category could not be merged."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = current_user.categories.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to categories_url, alert: "Category not found."
    end

    # Only allow a list of trusted parameters through.
    def category_params
      params.require(:category).permit(:name, :income, :untracked)
    end

    def merge_params
      params.permit(:id, :merge_with, :tag_id, :tag_name)
    end
end
