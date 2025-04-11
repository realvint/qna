# frozen_string_literal: true

require "rails_helper"

RSpec.describe AttachmentsController do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  shared_examples "for any attachable record" do |factory|
    let(:record) { create(factory, author: user) }

    before do
      record.files.attach(io: File.open(Rails.root.join("spec/rails_helper.rb").to_s), filename: "rails_helper.rb")
    end

    let(:attachment) { record.files.first }

    describe "DELETE #destroy" do
      context "as author" do
        before { login(user) }

        it "deletes the attachment" do
          expect do
            delete :destroy, params: { id: attachment }, format: :js
          end.to change(ActiveStorage::Attachment, :count).by(-1)
        end

        it "responds with JS" do
          delete :destroy, params: { id: attachment }, format: :js
          expect(response.media_type).to eq "text/javascript"
          expect(response).to be_successful
        end
      end

      context "as non-author" do
        before { login(other_user) }

        it "does not delete the attachment" do
          expect do
            delete :destroy, params: { id: attachment }, format: :js
          end.not_to change(ActiveStorage::Attachment, :count)
        end

        it "responds with forbidden" do
          delete :destroy, params: { id: attachment }, format: :js
          expect(response).to have_http_status(:forbidden)
        end
      end

      context "as guest" do
        it "does not delete the attachment and redirects to sign in" do
          expect do
            delete :destroy, params: { id: attachment }, format: :js
          end.not_to change(ActiveStorage::Attachment, :count)
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end

  include_examples "for any attachable record", :question
  include_examples "for any attachable record", :answer
end
