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
    before do
      visit root_path
    end

    context "ページあたりに表示する件数以上のレコードがある場合" do
      let!(:micropost) { 50.times { FactoryGirl.create(:micropost, user: user ) } }
      before do
        visit root_path
      end

      it { should have_selector('div.pagination') }

      it "ページ毎に microost が存在する" do
        user.microposts.paginate(page: 1).each do |micropost|
         expect(page).to have_selector('li', text: micropost.content )
        end
        user.microposts.paginate(page: 2).each do |micropost|
         expect(page).to have_selector('li', text: micropost.content )
        end
      end
    end

    context "ページネーションのしきい値の場合 " do
      let!(:micropost) { 30.times { FactoryGirl.create(:micropost) } }

      it "２ページ目に micropost が存在しない" do
        user.microposts.paginate(page: 2).each do |micropost|
         expect(page).to have_not_selector('li', text: micropost.content )
        end
      end
    end

    context "ページネーションのしきい値に＋１した場合" do
      let!(:micropost) { 31.times { FactoryGirl.create(:micropost) } }

      it "２ページ目に micropost が存在する" do
        user.microposts.paginate(page: 2).each do |micropost|
          expect(page).to have_selector('li', text: micropost.content )
        end
      end
    end
  end
end
