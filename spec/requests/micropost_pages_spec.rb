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
    let(:pagenation_threshold) { 30 }

    context "When number of micropost be the same as the threshold of pagination" do
      before do
        FactoryGirl.create_list(:micropost, pagenation_threshold, user: user )
        visit user_path(user)
      end

      it "Micropost is displayed on the first page" do
        expect(page).to     have_selector('ol.microposts li', count: 30)
        expect(page).not_to have_selector('div.pagination')
      end
    end

    context "When there is a Micropost +1 threshold of pagination" do
      before do
        FactoryGirl.create_list(:micropost, pagenation_threshold + 1, user: user )
        visit user_path(user)
      end

      it "Micropost is displayed on the first page" do
        expect(page).to have_selector('ol.microposts li', count: 30)
        expect(page).to have_selector('div.pagination')
        expect(page).to have_selector('li.active', text: '1')
      end

      it "Micropost is displayed on the second page" do
        click_link('2')
        expect(page).to have_selector('ol.microposts li', count: 1)
        expect(page).to have_selector('li.active', text: '2')
      end
    end
  end
end
