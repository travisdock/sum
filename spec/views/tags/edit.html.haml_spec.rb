require 'rails_helper'

RSpec.describe "tags/edit", type: :view do
  let(:tag) {
    Tag.create!()
  }

  before(:each) do
    assign(:tag, tag)
  end

  it "renders the edit tag form" do
    render

    assert_select "form[action=?][method=?]", tag_path(tag), "post" do
    end
  end
end
