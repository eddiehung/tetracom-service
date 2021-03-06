require 'spec_helper'

describe "Static pages" do

	subject { page }

	shared_examples_for "all static pages" do
		it { should have_selector('h1', text: heading) }
		it { should have_title(full_title(page_title)) }
	end

	describe "Home page" do
		before { visit root_path }
		let(:heading) { 'Consultation Service' }
		let(:page_title) { '' }

		it_should_behave_like "all static pages"
		it { should_not have_title('| Home') }

		describe "for signed-in users" do
			let(:user) { FactoryGirl.create(:user) }
			before do
				sign_in user
				visit root_path
			end

			describe "follower/following counts" do
				let(:other_user) { FactoryGirl.create(:user) }
				before do
					other_user.follow!(user)
					visit root_path
				end

				it { should have_link("0 experts", href: following_user_path(user)) }
				it { should have_link("1 requests", href: followers_user_path(user)) }
			end
		end
	end

	describe "Help page" do
		before { visit help_path }
		let(:heading) { 'Help' }
		let(:page_title) { 'Help' }

		it_should_behave_like "all static pages"
	end

	describe "About page" do
		before { visit about_path }
		let(:heading) { 'About us' }
		let(:page_title) { 'About us' }

		it_should_behave_like "all static pages"
	end

	describe "Contact page" do
		before { visit contact_path }
		let(:heading) { 'Contact' }
		let(:page_title) { 'Contact' }

		it_should_behave_like "all static pages"
	end

	it "should have the right links on the layout" do
		visit root_path
		click_link "Home"
		expect(page).to have_title(full_title(''))
		click_link "Help"
		expect(page).to have_title(full_title('Help'))
		#click_link "Sign in"
		first(:link, "Sign in").click
		expect(page).to have_title(full_title('Sign in'))
		click_link "About"
		expect(page).to have_title(full_title('About us'))
		click_link "Contact"
		expect(page).to have_title(full_title('Contact'))
	end
end
