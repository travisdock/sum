require 'rails_helper'

RSpec.describe ApiToken, type: :model do
  before(:all) do
    @user = User.create!(email_address: 'api-token-model@mail.com', password: '123456')
  end

  after(:all) do
    @user.destroy
  end

  it 'generates a plaintext token and stores only its digest' do
    api_token = ApiToken.create!(user: @user, name: 'Test Token')
    expect(api_token.plaintext_token).to start_with('sum_')
    expect(api_token.token_digest).to eq(Digest::SHA256.hexdigest(api_token.plaintext_token))
  end

  it 'does not expose the plaintext token after reload' do
    api_token = ApiToken.create!(user: @user, name: 'Test Token')
    expect(ApiToken.find(api_token.id).plaintext_token).to be_nil
  end

  it 'requires a name' do
    api_token = ApiToken.new(user: @user)
    expect(api_token).not_to be_valid
    expect(api_token.errors[:name]).to be_present
  end

  it 'requires the name to be unique per user' do
    ApiToken.create!(user: @user, name: 'Duplicate Name')
    duplicate = ApiToken.new(user: @user, name: 'Duplicate Name')

    expect(duplicate).not_to be_valid
    expect(duplicate.errors[:name]).to be_present
  end

  it 'allows the same name across different users' do
    other_user = User.create!(email_address: 'api-token-model-other@mail.com', password: '123456')
    ApiToken.create!(user: @user, name: 'Shared Name')
    same_name_other_user = ApiToken.new(user: other_user, name: 'Shared Name')

    expect(same_name_other_user).to be_valid
    other_user.destroy
  end

  it 'enforces per-user name uniqueness at the database level even if validation is bypassed' do
    ApiToken.create!(user: @user, name: 'DB Level Unique')
    # `validate: false` skips the before_validation token-generation callback too, so set
    # a distinct token_digest by hand to isolate this test to the [user_id, name] index.
    duplicate = ApiToken.new(user: @user, name: 'DB Level Unique', token_digest: SecureRandom.hex(32))

    expect { duplicate.save(validate: false) }.to raise_error(ActiveRecord::RecordNotUnique)
  end

  it 'enforces uniqueness of token_digest when every retry keeps colliding' do
    allow(SecureRandom).to receive(:hex).and_return('deadbeef')
    ApiToken.create!(user: @user, name: 'First')
    duplicate = ApiToken.new(user: @user, name: 'Second')
    expect(duplicate).not_to be_valid
    expect(duplicate.errors[:token_digest]).to be_present
  end

  it 'retries token generation when the first draw collides' do
    existing = ApiToken.create!(user: @user, name: 'Existing')
    colliding_hex = existing.plaintext_token.delete_prefix(ApiToken::TOKEN_PREFIX)
    call_count = 0
    allow(SecureRandom).to receive(:hex) do
      call_count += 1
      call_count == 1 ? colliding_hex : 'a-unique-retry-hex'
    end

    retried = ApiToken.create!(user: @user, name: 'Retried')

    expect(call_count).to be >= 2
    expect(retried.token_digest).not_to eq(existing.token_digest)
  end

  describe '.authenticate' do
    it 'returns the matching token for a valid raw token' do
      api_token = ApiToken.create!(user: @user, name: 'Test Token')
      expect(ApiToken.authenticate(api_token.plaintext_token)).to eq(api_token)
    end

    it 'returns nil for an unknown token' do
      expect(ApiToken.authenticate('sum_does-not-exist')).to be_nil
    end

    it 'returns nil for a blank token' do
      expect(ApiToken.authenticate(nil)).to be_nil
      expect(ApiToken.authenticate('')).to be_nil
    end

    it 'records usage on each authentication' do
      api_token = ApiToken.create!(user: @user, name: 'Test Token')
      expect {
        ApiToken.authenticate(api_token.plaintext_token)
      }.to change { api_token.reload.request_count }.from(0).to(1)
      expect(api_token.last_used_at).to be_present

      expect {
        ApiToken.authenticate(api_token.plaintext_token)
      }.to change { api_token.reload.request_count }.from(1).to(2)
    end
  end
end
