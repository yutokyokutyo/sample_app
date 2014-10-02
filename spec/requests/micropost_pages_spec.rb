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

  describe "pagination" do

    context "When number of micropost be the same as the threshold of pagination" do
      let!(:Micropost) { 30.times { FactoryGirl.create(:micropost, user: user ) } }

      before do
        visit user_path(user)
      end

      it "Micropost is displayed on the first page" do
        user.microposts.paginate(page: 1).each do |micropost|
          expect(page).to have_selector('span', text: micropost.content )
        end
      end

      it { should_not have_selector('div.pagination') }
    end

    context "When there is a Micropost +1 threshold of pagination" do
      let!(:Micropost) { 31.times { FactoryGirl.create(:micropost, user: user ) } }

      before do
        visit user_path(user)
      end

      it { should have_selector('div.pagination') }

      it "Micropost is displayed on the first page" do
        user.microposts.paginate(page: 1).each do |micropost|
          expect(page).to have_selector('span', text: micropost.content )
        end
      end

      it "Can move to next page" do
        click_link('2')
      end

      it "Micropost is displayed on the second page" do
        user.microposts.paginate(page: 2).each do |micropost|
          expect(page).to have_selector('span', text: micropost.content )
        end
      end

      it "Can move to previous page" do
        click_link('1')
      end
    end
  end
end
