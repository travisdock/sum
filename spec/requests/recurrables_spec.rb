require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/recurrables", type: :request do
  
  # This should return the minimal set of attributes required to create a valid
  # Recurrable. As you add validations to Recurrable, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET /index" do
    it "renders a successful response" do
      Recurrable.create! valid_attributes
      get recurrables_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      recurrable = Recurrable.create! valid_attributes
      get recurrable_url(recurrable)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_recurrable_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      recurrable = Recurrable.create! valid_attributes
      get edit_recurrable_url(recurrable)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Recurrable" do
        expect {
          post recurrables_url, params: { recurrable: valid_attributes }
        }.to change(Recurrable, :count).by(1)
      end

      it "redirects to the created recurrable" do
        post recurrables_url, params: { recurrable: valid_attributes }
        expect(response).to redirect_to(recurrable_url(Recurrable.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Recurrable" do
        expect {
          post recurrables_url, params: { recurrable: invalid_attributes }
        }.to change(Recurrable, :count).by(0)
      end

    
      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post recurrables_url, params: { recurrable: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested recurrable" do
        recurrable = Recurrable.create! valid_attributes
        patch recurrable_url(recurrable), params: { recurrable: new_attributes }
        recurrable.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the recurrable" do
        recurrable = Recurrable.create! valid_attributes
        patch recurrable_url(recurrable), params: { recurrable: new_attributes }
        recurrable.reload
        expect(response).to redirect_to(recurrable_url(recurrable))
      end
    end

    context "with invalid parameters" do
    
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        recurrable = Recurrable.create! valid_attributes
        patch recurrable_url(recurrable), params: { recurrable: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested recurrable" do
      recurrable = Recurrable.create! valid_attributes
      expect {
        delete recurrable_url(recurrable)
      }.to change(Recurrable, :count).by(-1)
    end

    it "redirects to the recurrables list" do
      recurrable = Recurrable.create! valid_attributes
      delete recurrable_url(recurrable)
      expect(response).to redirect_to(recurrables_url)
    end
  end
end