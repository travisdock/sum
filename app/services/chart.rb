class Chart
  def self.profit_loss(user_id:, start_date: Date.today.beginning_of_year, end_date: Date.today.end_of_year)
    data = Entry.includes(:category).where(user_id:, date: start_date..end_date).by_untracked(false).group_by { |e| e.date.strftime('%B %Y') }
    profit_and_loss = {}
    data.each do |month_year, entries|
      total = entries.sum{ |e| e.category.income? ? e.amount : -e.amount }
      profit_and_loss[month_year] = format('%.2f', total)
    end

    profit_and_loss
  end
end
