module DemoDataGenerator
  extend self

  def random_amount(base, variance = 0.2)
    min = base * (1 - variance)
    max = base * (1 + variance)
    (rand * (max - min) + min).round(2)
  end

  def maybe_add_tag(tags, probability = 0.15)
    rand < probability ? tags.values.sample : nil
  end

  def maybe_add_notes(category_name, amount = nil)
    category_notes = {
      'Salary' => ['Monthly salary deposit', 'Regular paycheck', 'Direct deposit', 'Salary payment'],
      'Freelance' => ['Project payment', 'Client invoice', 'Consulting work', 'Contract payment', 'Freelance gig'],
      'Rent/Mortgage' => ['Monthly rent', 'Rent payment', 'Apartment rent', 'Housing payment'],
      'Groceries' => ['Weekly groceries', 'Whole Foods', "Trader Joe's", 'Safeway run', 'Costco trip',
                      'Farmers market'],
      'Utilities' => ['Electric bill', 'Gas & electric', 'Water bill', 'Internet service', 'Phone bill'],
      'Transportation' => ['Gas', 'Uber ride', 'Bus pass', 'Parking', 'Train ticket', 'Car maintenance'],
      'Entertainment' => ['Movie tickets', 'Concert', 'Netflix', 'Game purchase', 'Event tickets', 'Streaming service'],
      'Healthcare' => ['Doctor visit', 'Prescription', 'Dentist', 'Eye exam', 'Lab work', 'Pharmacy'],
      'Shopping' => ['Amazon purchase', 'Clothing', 'Home supplies', 'Electronics', 'Books', 'Target run'],
      'Restaurants' => ['Lunch', 'Dinner out', 'Coffee shop', 'Takeout', 'Date night', 'Brunch'],
      'Insurance' => ['Health insurance', 'Car insurance', 'Life insurance', 'Insurance premium'],
      'Subscriptions' => ['Spotify', 'Netflix', 'Gym membership', 'Cloud storage', 'Software subscription']
    }

    # 60% chance of having notes
    if rand < 0.6
      notes_array = category_notes[category_name] || ['Payment', 'Purchase', 'Transaction']
      notes_array.sample
    else
      nil
    end
  end

  def generate_daily_expenses(user, categories, tags, date)
    entries_created = 0

    # Groceries (2-3 times per week)
    if [1, 4, 6].include?(date.wday) && rand < 0.8
      user.entries.create!(
        category: categories[:groceries],
        date: date,
        amount: random_amount(100, 0.4),
        notes: maybe_add_notes('Groceries'),
        tag: maybe_add_tag(tags, 0.1)
      )
      entries_created += 1
    end

    # Transportation (weekdays, 70% chance)
    if ![0, 6].include?(date.wday) && rand < 0.7
      user.entries.create!(
        category: categories[:transportation],
        date: date,
        amount: random_amount(15, 0.5),
        notes: maybe_add_notes('Transportation'),
        tag: maybe_add_tag(tags, 0.15)
      )
      entries_created += 1
    end

    # Restaurants (25% chance any day)
    if rand < 0.25
      user.entries.create!(
        category: categories[:restaurants],
        date: date,
        amount: random_amount(45, 0.6),
        notes: maybe_add_notes('Restaurants'),
        tag: maybe_add_tag(tags, 0.2)
      )
      entries_created += 1
    end

    # Entertainment (weekends, 30% chance)
    if [0, 6].include?(date.wday) && rand < 0.3
      user.entries.create!(
        category: categories[:entertainment],
        date: date,
        amount: random_amount(60, 0.7),
        notes: maybe_add_notes('Entertainment'),
        tag: maybe_add_tag(tags, 0.2)
      )
      entries_created += 1
    end

    # Shopping (10% chance any day)
    if rand < 0.1
      user.entries.create!(
        category: categories[:shopping],
        date: date,
        amount: random_amount(90, 0.8),
        notes: maybe_add_notes('Shopping'),
        tag: maybe_add_tag(tags, 0.25)
      )
      entries_created += 1
    end

    # Healthcare (2% chance, higher amounts)
    if rand < 0.02
      user.entries.create!(
        category: categories[:healthcare],
        date: date,
        amount: random_amount(150, 0.9),
        notes: maybe_add_notes('Healthcare'),
        tag: tags[:personal]
      )
      entries_created += 1
    end

    entries_created
  end

  def get_large_expense_categories
    [
      { amount: random_amount(800, 0.6), note: 'Medical procedure' },
      { amount: random_amount(600, 0.5), note: 'Car repair' },
      { amount: random_amount(400, 0.4), note: 'Home repair' },
      { amount: random_amount(500, 0.3), note: 'Appliance purchase' }
    ]
  end

  def generate_monthly_salary(user, categories, tags, month_start, month_end)
    # Monthly salary (on the 25th or last business day before)
    salary_date = Date.new(month_start.year, month_start.month, 25)
    if salary_date.saturday?
      salary_date -= 1
    elsif salary_date.sunday?
      salary_date -= 2
    end

    if salary_date <= month_end && salary_date >= month_start
      user.entries.create!(
        category: categories[:salary],
        date: salary_date,
        amount: random_amount(4500, 0.02),
        notes: maybe_add_notes('Salary'),
        tag: maybe_add_tag(tags, 0.05)
      )
      return 1
    end
    0
  end

  def generate_freelance_income(user, categories, tags, month_start, month_end)
    # Freelance income (20% chance per month, random day)
    if rand < 0.2
      freelance_date = month_start + rand(0..27).days
      if freelance_date <= month_end
        user.entries.create!(
          category: categories[:freelance],
          date: freelance_date,
          amount: random_amount(1200, 0.5),
          notes: maybe_add_notes('Freelance'),
          tag: tags[:business]
        )
        return 1
      end
    end
    0
  end
end
