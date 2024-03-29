describe('The Happiest Path', () => {
  after(() => {
    cy.request('http://localhost:3000/clear_db')
  })

  it('the happy path', () => {
    // Create a new User
    cy.visit('http://localhost:3000')
    cy.get('.navbar-brand').should('contain', 'Sum')
    cy.get('a[href="/users/sign_up"]').click()
    cy.wait(500).get('input[name="user[email]"]').type('test@mail.com')
    cy.get('input[name="user[password]"]').type('testing')
    cy.get('input[name="user[password_confirmation]"]').type('testing')
    cy.get('input[name="commit"]').click()
    cy.get('.toast-header').should('contain', 'Welcome! You have signed up successfully.')
    // Log in with new user credentials
    cy.get('a[href="/users/sign_out"]').click()
    cy.wait(500).get('input[name="user[email]"]').type('test@mail.com')
    cy.get('input[name="user[password]"]').type('testing')
    cy.get('input[name="commit"]').click()
    cy.get('h1').should('contain', 'New entry')
    // Create a new category
    cy.get('a[href="/categories"]').click()
    cy.get('a[href="/categories/new"]').click()
    cy.wait(500).get('#category_name').type('Test Category')
    cy.get('input[name="commit"]').click()
    // Create a new Entry
    cy.wait(500).get('a[href="/entries"]').click()
    cy.wait(500).get('a[href="/entries/new"]').click()
    cy.wait(500).get('#entry_amount').type('100')
    cy.get('#entry_notes').type('These are test notes')
    cy.get('#entry_category_id').select('Test Category')
    cy.get('input[name="commit"]').click()
    // Create another Entry
    cy.wait(500).get('#entry_amount').type('250')
    cy.get('#entry_notes').type('These are test notes again')
    cy.get('#entry_category_id').select('Test Category')
    cy.get('input[name="commit"]').click()
    // Make sure entries table works
    cy.wait(500).get('a[href="/entries"]').click()
    cy.get('#toolbar').should('contain', 'Sum: $350.00')
    // Make sure filters work
    cy.get('#income').select('true')
    cy.get('input[name="commit"]').click()
    cy.wait(500).get('#toolbar').should('contain', 'Sum: $0.00')
    // Visit Tags page
    cy.get('a[href="/tags"]').click()
    cy.wait(500)
    // Visit Dashboard
    cy.get('a[href="/dashboard"]').click()
    cy.get('h5').should('contain', 'Total Spending')
    cy.get('h5').should('contain', 'Test Category')
    cy.get('input[value="Pie Chart"]').click()
    // Visit Account page
    cy.get('a[href="/users/edit"]').click()
    cy.get('button').contains('Cancel my account').click()
    cy.get('.toast-header').should('contain', 'Bye! Your account has been successfully cancelled. We hope to see you again soon.')
  })

})
