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

  describe "Sidebar micropost counts" do
    context "Micropost when the singular" do
      let!(:Micropost) { 1.times { FactoryGirl.create(:micropost, user: user ) } }
      before do
        visit root_path
      end

      it { should have_selector('aside.span4 span', text: user.microposts.count ) }
      it { should have_selector('aside.span4 span', text: "micropost") }
    end

    context "When formed into plurality of microposts" do
      let!(:Micropost) { 2.times { FactoryGirl.create(:micropost, user: user ) } }
      before do
        visit root_path
      end

      it { should have_selector('aside.span4 span', text: user.microposts.count ) }
      it { should have_selector('aside.span4 span', text: "microposts") }
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
end
