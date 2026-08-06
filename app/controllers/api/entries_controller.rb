module Api
  class EntriesController < Api::BaseController
    def create
      category = resolve_category
      return unless category # resolve_category already rendered the error response

      entry = current_user.entries.new(entry_params.merge(category: category))
      entry.tag_attributes = { name: params[:tag_name] } if params[:tag_name].present?

      if entry.save
        render json: { entry: serialize_entry(entry) }, status: :created
      else
        render json: {
          error: 'validation_failed',
          message: 'Entry could not be created.',
          details: entry.errors.full_messages
        }, status: :unprocessable_entity
      end
    end

    private

    def entry_params
      permitted = params.permit(:date, :amount, :notes, :income, :untracked)
      permitted.delete(:date) if permitted[:date].blank?
      permitted.reverse_merge(date: Date.current)
    end

    def resolve_category
      if params[:category_id].present?
        current_user.categories.find_by(id: params[:category_id]) || render_category_error(
          "No category with id #{params[:category_id]} found for this user."
        )
      elsif params[:category_name].present?
        current_user.categories.find_by(name: params[:category_name]) || render_category_error(
          "No category named #{params[:category_name].inspect} found for this user."
        )
      else
        render_category_error('Provide category_id or category_name.')
      end
    end

    def render_category_error(message)
      render json: {
        error: 'category_not_found',
        message: message,
        available_categories: current_user.categories.pluck(:name)
      }, status: :unprocessable_entity
      nil
    end

    def serialize_entry(entry)
      {
        id: entry.id,
        date: entry.date,
        amount: entry.amount,
        notes: entry.notes,
        income: entry.income,
        untracked: entry.untracked,
        category: { id: entry.category.id, name: entry.category.name },
        tag: entry.tag && { id: entry.tag.id, name: entry.tag.name }
      }
    end
  end
end
