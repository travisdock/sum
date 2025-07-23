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
end