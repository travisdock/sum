class ChartsController < ApplicationController
  def show
    @available_years = current_user.entries
                                   .pluck(Arel.sql("DISTINCT strftime('%Y', date)"))
                                   .compact
                                   .sort
                                   .reverse

    @selected_year = params[:year] || @available_years.first || Date.current.year.to_s

    @monthly_data = calculate_monthly_profit_loss(@selected_year)
  end

  def heatmap
    @available_years = current_user.entries
                                   .pluck(Arel.sql("DISTINCT strftime('%Y', date)"))
                                   .compact
                                   .sort
                                   .reverse

    @selected_year = params[:year] || @available_years.first || Date.current.year.to_s
    
    @heatmap_data = calculate_daily_expenses(@selected_year)
  end

  private

  def calculate_monthly_profit_loss(year)
    months = (1..12).map { |m| m.to_s }
    data = months.map do |month|
      entries = current_user.entries
                            .by_year(year)
                            .by_month(month)
                            .by_untracked(false)

      income = entries.by_income(true).sum(:amount)
      expenses = entries.by_income(false).sum(:amount)
      profit_loss = income - expenses

      {
        month: Date::MONTHNAMES[month.to_i],
        income: income,
        expenses: expenses,
        profit_loss: profit_loss
      }
    end

    data
  end

  def calculate_daily_expenses(year)
    start_date = Date.parse("#{year}-01-01")
    end_date = Date.parse("#{year}-12-31")
    
    # Get all expense entries for the year
    expense_entries = current_user.entries
                                  .by_year(year)
                                  .by_income(false)
                                  .by_untracked(false)
                                  .group(:date)
                                  .select('date, COUNT(*) as count, SUM(amount) as total')
    
    # Convert to hash for easy lookup
    expenses_by_date = expense_entries.each_with_object({}) do |entry, hash|
      hash[entry.date.to_s] = {
        count: entry.count,
        total: entry.total.to_f
      }
    end
    
    # Build complete year data with zeros for days without expenses
    daily_data = {}
    (start_date..end_date).each do |date|
      date_key = date.to_s
      daily_data[date_key] = expenses_by_date[date_key] || { count: 0, total: 0.0 }
    end
    
    # Calculate max expense for scaling
    max_expense = daily_data.values.map { |d| d[:total] }.max || 0
    
    {
      daily_expenses: daily_data,
      max_expense: max_expense,
      year: year
    }
  end
end
