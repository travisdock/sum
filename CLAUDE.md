## ClaudeOnRails Configuration

You are working on Sum, a Rails application. Review the ClaudeOnRails context file at @.claude-on-rails/context.md

## Authentication System

This application uses a vanilla Rails authentication system (not Devise):
- Authentication is handled by `app/controllers/concerns/authentication.rb`
- Sessions are cookie-based with a 1-month timeout
- User model uses `has_secure_password` with bcrypt
- Authentication routes: `/login`, `/logout`, `/signup`, `/users/:id/edit`
- Controllers use `authenticate_user!`, `current_user`, and `user_signed_in?` helpers

## Ruby Version Notes

This project uses Ruby 3.4.4. Note that some standard libraries like CSV are no longer bundled with Ruby 3.4+ and need to be added to the Gemfile if required.

## Views

This project uses HAML for views, not ERB. All view files use the `.html.haml` extension.

## Testing

- Run tests with `bundle exec rspec`
- Authentication helpers for tests are in `spec/support/authentication_helpers.rb`
- Use `sign_in(user)` in controller specs to authenticate
