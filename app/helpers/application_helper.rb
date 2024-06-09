module ApplicationHelper
  def sort_direction(column)
    params.dig(:q, :s) == "#{column} asc" ? "desc" : "asc"
  end
end
