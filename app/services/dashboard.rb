class Dashboard
  attr_accessor :entries

  def initialize(entries)
    @entries = entries
  end

  def last_entry_date
    @entries.order(:date).last.date
  end

  def total_spending
    @entries.by_income(false).by_untracked(false).sum(:amount)
  end

  def total_income
    @entries.by_income(true).by_untracked(false).sum(:amount)
  end

  def profit_loss
    total_income - total_spending
  end

  def category_totals
    @entries.joins(:category).group(:name).sum(:amount)
  end
end
