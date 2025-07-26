class UpdateDemoDataJob < ApplicationJob
  include DemoDataGenerator
  
  queue_as :default

  def perform
    # Only update data for the demo user
    demo_user = User.find_by(email_address: "demo@example.com")
    return unless demo_user

    # Get the date range for the past week
    end_date = Date.today
    start_date = end_date - 7.days

    # Skip if we already have recent data (to avoid duplicates if job runs multiple times)
    latest_entry = demo_user.entries.order(date: :desc).first
    return if latest_entry && latest_entry.date >= start_date

    # Get categories and tags
    categories = {}
    demo_user.categories.each do |cat|
      key = cat.name.downcase.gsub(/[^a-z]/, '_').to_sym
      categories[key] = cat
    end

    tags = {}
    Tag.all.each do |tag|
      key = tag.name.downcase.gsub(/[^a-z]/, '_').to_sym
      tags[key] = tag
    end

    entry_count = 0

    # Generate entries for each day of the past week
    (start_date..end_date).each do |date|
      # Skip if we already have entries for this date
      next if demo_user.entries.where(date: date).exists?

      # Generate daily expenses using shared module
      entry_count += generate_daily_expenses(demo_user, categories, tags, date)
    end

    # Handle monthly transactions if we're in a new month
    if start_date.month != end_date.month || start_date.year != end_date.year
      current_month = end_date.beginning_of_month
      
      # Check if monthly transactions already exist for this month
      unless demo_user.entries.where(date: current_month..end_date).joins(:category).where(categories: { name: "Salary" }).exists?
        entry_count += generate_monthly_salary(demo_user, categories, tags, start_date, end_date)
      end

      # Add other monthly expenses if they fall within our date range
      # These would normally be handled by Recurrable.create_occurrences
      # but we'll check and add them if missing
      
      # Occasional large expense (40% chance)
      if rand < 0.4 && !demo_user.entries.where(date: current_month..end_date, amount: 400..1000).exists?
        large_expense_date = current_month + rand(5..25).days
        if large_expense_date <= end_date && large_expense_date >= start_date
          expense_options = get_large_expense_categories
          expense = expense_options.sample
          expense[:category] = [categories[:healthcare], categories[:transportation], categories[:shopping], categories[:shopping]].sample
          demo_user.entries.create!(
            category: expense[:category],
            date: large_expense_date,
            amount: expense[:amount],
            notes: expense[:note],
            tag: tags[:emergency]
          )
          entry_count += 1
        end
      end
    end

    Rails.logger.info "UpdateDemoDataJob: Created #{entry_count} new entries for demo user"
  end
end