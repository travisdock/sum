# Demo data generator for Sum - Personal Finance Application
# Creates 3 years of realistic financial data for demonstration purposes

puts 'Seeding database...'

# Clear existing data
Entry.destroy_all
Recurrable.destroy_all
Tag.destroy_all
Category.destroy_all
User.destroy_all

# Create demo user
demo_user = User.create!(
  email_address: 'demo@example.com',
  password: 'password123'
)
puts "Created demo user: #{demo_user.email_address}"

# Create categories
categories = {}

# Income categories
categories[:salary] = Category.create!(name: 'Salary', income: true, untracked: false)
categories[:freelance] = Category.create!(name: 'Freelance', income: true, untracked: false)

# Expense categories
categories[:rent] = Category.create!(name: 'Rent/Mortgage', income: false, untracked: false)
categories[:groceries] = Category.create!(name: 'Groceries', income: false, untracked: false)
categories[:utilities] = Category.create!(name: 'Utilities', income: false, untracked: false)
categories[:transportation] = Category.create!(name: 'Transportation', income: false, untracked: false)
categories[:entertainment] = Category.create!(name: 'Entertainment', income: false, untracked: false)
categories[:healthcare] = Category.create!(name: 'Healthcare', income: false, untracked: false)
categories[:shopping] = Category.create!(name: 'Shopping', income: false, untracked: false)
categories[:restaurants] = Category.create!(name: 'Restaurants', income: false, untracked: false)
categories[:insurance] = Category.create!(name: 'Insurance', income: false, untracked: false)
categories[:subscriptions] = Category.create!(name: 'Subscriptions', income: false, untracked: false)

# Associate categories with user
demo_user.categories << categories.values

puts "Created #{categories.count} categories"

# Create tags
tags = {}
tags[:tax_deductible] = Tag.create!(name: 'Tax Deductible')
tags[:business] = Tag.create!(name: 'Business')
tags[:personal] = Tag.create!(name: 'Personal')
tags[:emergency] = Tag.create!(name: 'Emergency')
tags[:vacation] = Tag.create!(name: 'Vacation')
tags[:gift] = Tag.create!(name: 'Gift')
tags[:refund] = Tag.create!(name: 'Refund')
tags[:reimbursable] = Tag.create!(name: 'Reimbursable')

puts "Created #{tags.count} tags"

# Include the demo data generator module
require_relative '../app/services/demo_data_generator'
include DemoDataGenerator

# Generate entries for the past 3 years
end_date = Date.today
start_date = end_date - 3.years
entry_count = 0

puts "Generating entries from #{start_date} to #{end_date}..."

# Iterate through each month
current_date = start_date
while current_date <= end_date
  month_start = current_date.beginning_of_month
  month_end = [current_date.end_of_month, end_date].min

  # Monthly salary
  entry_count += generate_monthly_salary(demo_user, categories, tags, month_start, month_end)

  # Freelance income
  entry_count += generate_freelance_income(demo_user, categories, tags, month_start, month_end)

  # Monthly rent (1st of month)
  rent_date = month_start
  if rent_date <= month_end
    Entry.create!(
      user: demo_user,
      category: categories[:rent],
      date: rent_date,
      amount: random_amount(1800, 0),
      notes: maybe_add_notes('Rent/Mortgage'),
      tag: maybe_add_tag(tags, 0.05)
    )
    entry_count += 1
  end

  # Utilities (around 15th)
  utilities_date = month_start + 14.days
  if utilities_date <= month_end
    Entry.create!(
      user: demo_user,
      category: categories[:utilities],
      date: utilities_date,
      amount: random_amount(150, 0.3),
      notes: maybe_add_notes('Utilities'),
      tag: maybe_add_tag(tags, 0.1)
    )
    entry_count += 1
  end

  # Insurance (10th of month)
  insurance_date = month_start + 9.days
  if insurance_date <= month_end
    Entry.create!(
      user: demo_user,
      category: categories[:insurance],
      date: insurance_date,
      amount: random_amount(200, 0.1),
      notes: maybe_add_notes('Insurance'),
      tag: maybe_add_tag(tags, 0.05)
    )
    entry_count += 1
  end

  # Daily expenses
  (month_start..month_end).each do |date|
    entry_count += generate_daily_expenses(demo_user, categories, tags, date)
  end

  # Subscriptions (various days of month)
  if (month_start + 4.days) <= month_end
    Entry.create!(
      user: demo_user,
      category: categories[:subscriptions],
      date: month_start + 4.days,
      amount: 14.99,
      notes: maybe_add_notes('Subscriptions'),
      tag: maybe_add_tag(tags, 0.05)
    )
    entry_count += 1
  end

  if (month_start + 11.days) <= month_end
    Entry.create!(
      user: demo_user,
      category: categories[:subscriptions],
      date: month_start + 11.days,
      amount: 9.99,
      notes: maybe_add_notes('Subscriptions'),
      tag: maybe_add_tag(tags, 0.05)
    )
    entry_count += 1
  end

  # Add occasional large expenses (car repair, medical bills, home repair, etc.)
  # 40% chance of a large unexpected expense each month
  if rand < 0.4
    large_expense_date = month_start + rand(5..25).days
    if large_expense_date <= month_end
      expense_options = get_large_expense_categories
      expense = expense_options.sample
      expense[:category] =
        [categories[:healthcare], categories[:transportation], categories[:shopping], categories[:shopping]].sample
      Entry.create!(
        user: demo_user,
        category: expense[:category],
        date: large_expense_date,
        amount: expense[:amount],
        notes: expense[:note],
        tag: tags[:emergency]
      )
      entry_count += 1
    end
  end

  # Holiday shopping in November/December
  if [11, 12].include?(month_start.month)
    (month_start..month_end).each do |date|
      if rand < 0.15 # 15% chance each day
        Entry.create!(
          user: demo_user,
          category: categories[:shopping],
          date: date,
          amount: random_amount(120, 0.6),
          notes: 'Holiday shopping',
          tag: tags[:gift]
        )
        entry_count += 1
      end
    end
  end

  # Vacation expenses (summer months)
  if [6, 7, 8].include?(month_start.month) && rand < 0.3
    vacation_days = rand(3..7)
    vacation_start = month_start + rand(0..20).days

    vacation_days.times do |day|
      vacation_date = vacation_start + day.days
      if vacation_date <= month_end && vacation_date >= month_start
        # Hotel
        Entry.create!(
          user: demo_user,
          category: categories[:entertainment],
          date: vacation_date,
          amount: random_amount(150, 0.3),
          notes: 'Hotel',
          tag: tags[:vacation]
        )
        entry_count += 1

        # Dining out more
        Entry.create!(
          user: demo_user,
          category: categories[:restaurants],
          date: vacation_date,
          amount: random_amount(80, 0.4),
          notes: 'Vacation dining',
          tag: tags[:vacation]
        )
        entry_count += 1
      end
    end
  end

  current_date = (current_date + 1.month).beginning_of_month
end

puts "Created #{entry_count} entries"

# Create recurring transactions for ongoing expenses
recurrables = []

recurrables << Recurrable.create!(
  user: demo_user,
  category: categories[:salary],
  name: 'Monthly Salary',
  day_of_month: 25,
  amount: 4500.00,
  notes: 'Monthly salary payment'
)

recurrables << Recurrable.create!(
  user: demo_user,
  category: categories[:rent],
  name: 'Monthly Rent',
  day_of_month: 1,
  amount: 1800.00,
  notes: 'Monthly rent payment'
)

recurrables << Recurrable.create!(
  user: demo_user,
  category: categories[:utilities],
  name: 'Utilities',
  day_of_month: 15,
  amount: 150.00,
  notes: 'Electric and gas'
)

recurrables << Recurrable.create!(
  user: demo_user,
  category: categories[:insurance],
  name: 'Insurance',
  day_of_month: 10,
  amount: 200.00,
  notes: 'Health and auto insurance'
)

recurrables << Recurrable.create!(
  user: demo_user,
  category: categories[:subscriptions],
  name: 'Streaming Service',
  day_of_month: 5,
  amount: 14.99,
  notes: 'Monthly streaming subscription'
)

puts "Created #{recurrables.count} recurring transactions"

puts "\nSeeding complete!"
puts 'Demo login: demo@example.com / password123'
puts "Generated #{entry_count} financial entries spanning 3 years"
