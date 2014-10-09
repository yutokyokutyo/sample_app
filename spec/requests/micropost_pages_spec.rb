require 'spec_helper'

describe "Micropost pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "micropost creation" do
    before { visit root_path }

    describe "with invalid information" do

      it "should not create a micropost" do
        expect { click_button "Post" }.not_to change(Micropost, :count)
      end
      describe "error messages" do
        before { click_button "Post" }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do

      before { fill_in 'micropost_content', with: "Lorem ipsum" }
      it "should create a micropost" do
        expect { click_button "Post" }.to change(Micropost, :count).by(1)
      end
    end
  end

  describe "micropost destruction" do
    before { FactoryGirl.create(:micropost, user: user) }

    describe "as correct user" do
      before { visit root_path }

      it "should delete a micropost" do
        expect { click_link "delete" }.to change(Micropost, :count).by(-1)
      end
    end
  end

  describe "Current user can not see the delete link of micropost other users" do
    context "Micropost of the current user display delete link" do
      before do
        FactoryGirl.create(:micropost, user: user)
        visit user_path(user)
      end

      it { should have_link('delete') }
    end

    context "Micropost of the other user display without delete link" do
      let(:other) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: other)
        visit user_path(other)
      end

      it { should_not have_link('delete') }
    end
  end
end
