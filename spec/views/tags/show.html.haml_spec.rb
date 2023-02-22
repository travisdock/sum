require 'rails_helper'

RSpec.describe "tags/show", type: :view do
  before(:each) do
    assign(:tag, Tag.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
