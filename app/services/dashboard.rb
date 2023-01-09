class Dashboard
  attr_accessor :entries

  def initialize(entries)
    @entries = entries
  end

  def last_entry_date
    @entries.order(:date).last.date
  end

  def total_spending
    @entries.joins(:category).where('category.income' => false).where('category.untracked' => false).sum(:amount)
  end

  def total_income
    @entries.joins(:category).where('category.income' => true).where('category.untracked' => false).sum(:amount)
  end

  def profit_loss
    total_income - total_spending
  end

  def category_totals
    @entries.joins(:category).group(:name).sum(:amount)
  end

  def total_spending_by_month
    @entries.group('(EXTRACT(MONTH FROM date))::integer')
            .joins(:category).where('category.income' => false)
            .sum(:amount)
            .transform_keys { |key| Date::MONTHNAMES[key] }
  end
end
