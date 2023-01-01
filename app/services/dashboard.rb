class Dashboard
  attr_accessor :entries

  def initialize(entries)
    @entries = entries
  end

  def total_spending
    @entries.joins(:category).where('category.income' => false).where('category.untracked' => false).sum(:amount)
  end

  def total_income
    @entries.joins(:category).where('category.income' => true).where('category.untracked' => false).sum(:amount)
  end

  def category_totals
    @entries.joins(:category).group(:name).sum(:amount)
  end
end
