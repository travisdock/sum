class TagsController < ApplicationController
  before_action :set_tag, only: %i[ show edit update destroy ]

  # GET /tags
  def index
    ids = Entry.where(user: current_user).pluck(:tag_id)
    @tags = Tag.where(id: ids)
  end

  # GET /tags/1
  def show
  end

  # GET /tags/new
  def new
    @tag = Tag.new
  end

  # GET /tags/1/edit
  def edit
  end

  # POST /tags
  def create
    @tag = Tag.new(tag_params)

    if @tag.save
      redirect_to tag_url(@tag), notice: "Tag was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tags/1
  def update
    if @tag.update(tag_params)
      redirect_to tags_url, notice: "Tag was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /tags/1
  def destroy
    Entry.where(tag_id: @tag.id).update_all(tag_id: nil)
    @tag.destroy

    redirect_to tags_url, notice: "Tag was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tag
      ids = Entry.where(user: current_user).pluck(:tag_id)
      if ids.include?(params[:id].to_i)
        @tag = Tag.find(params[:id])
      else
        redirect_to tags_url, notice: "Tag not found."
      end
    end

    # Only allow a list of trusted parameters through.
    def tag_params
      params.require(:tag).permit(:name)
    end
end
