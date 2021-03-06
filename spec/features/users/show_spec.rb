# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'User page' do
  include ExternalAuthorizationServiceHelpers

  let(:user) { create(:user, bio: '**Lorem** _ipsum_ dolor sit [amet](https://example.com)') }

  context 'with public profile' do
    it 'shows all the tabs' do
      visit(user_path(user))

      page.within '.nav-links' do
        expect(page).to have_link('Overview')
        expect(page).to have_link('Activity')
        expect(page).to have_link('Groups')
        expect(page).to have_link('Contributed projects')
        expect(page).to have_link('Personal projects')
        expect(page).to have_link('Snippets')
      end
    end

    it 'does not show private profile message' do
      visit(user_path(user))

      expect(page).not_to have_content("This user has a private profile")
    end

    context 'work information' do
      subject { visit(user_path(user)) }

      it 'shows job title and organization details' do
        user.update(organization: 'GitLab - work info test', job_title: 'Frontend Engineer')

        subject

        expect(page).to have_content('Frontend Engineer at GitLab - work info test')
      end

      it 'shows job title' do
        user.update(organization: nil, job_title: 'Frontend Engineer - work info test')

        subject

        expect(page).to have_content('Frontend Engineer - work info test')
      end

      it 'shows organization details' do
        user.update(organization: 'GitLab - work info test', job_title: '')

        subject

        expect(page).to have_content('GitLab - work info test')
      end
    end
  end

  context 'with private profile' do
    let(:user) { create(:user, private_profile: true) }

    it 'shows no tab' do
      visit(user_path(user))

      expect(page).to have_css("div.profile-header")
      expect(page).not_to have_css("ul.nav-links")
    end

    it 'shows private profile message' do
      visit(user_path(user))

      expect(page).to have_content("This user has a private profile")
    end

    it 'shows own tabs' do
      sign_in(user)
      visit(user_path(user))

      page.within '.nav-links' do
        expect(page).to have_link('Overview')
        expect(page).to have_link('Activity')
        expect(page).to have_link('Groups')
        expect(page).to have_link('Contributed projects')
        expect(page).to have_link('Personal projects')
        expect(page).to have_link('Snippets')
      end
    end
  end

  context 'with blocked profile' do
    let(:user) { create(:user, state: :blocked) }

    it 'shows no tab' do
      visit(user_path(user))

      expect(page).to have_css("div.profile-header")
      expect(page).not_to have_css("ul.nav-links")
    end

    it 'shows blocked message' do
      visit(user_path(user))

      expect(page).to have_content("This user is blocked")
    end

    it 'shows user name as blocked' do
      visit(user_path(user))

      expect(page).to have_css(".cover-title", text: 'Blocked user')
    end

    it 'shows no additional fields' do
      visit(user_path(user))

      expect(page).not_to have_css(".profile-user-bio")
      expect(page).not_to have_css(".profile-link-holder")
    end

    it 'shows username' do
      visit(user_path(user))

      expect(page).to have_content("@#{user.username}")
    end
  end

  it 'shows the status if there was one' do
    create(:user_status, user: user, message: "Working hard!")

    visit(user_path(user))

    expect(page).to have_content("Working hard!")
  end

  context 'signup disabled' do
    it 'shows the sign in link' do
      stub_application_setting(signup_enabled: false)

      visit(user_path(user))

      page.within '.navbar-nav' do
        expect(page).to have_link('Sign in')
      end
    end
  end

  context 'signup enabled' do
    it 'shows the sign in and register link' do
      stub_application_setting(signup_enabled: true)

      visit(user_path(user))

      page.within '.navbar-nav' do
        expect(page).to have_link('Sign in / Register')
      end
    end
  end

  context 'most recent activity' do
    it 'shows the most recent activity' do
      visit(user_path(user))

      expect(page).to have_content('Most Recent Activity')
    end

    context 'when external authorization is enabled' do
      before do
        enable_external_authorization_service_check
      end

      it 'hides the most recent activity' do
        visit(user_path(user))

        expect(page).not_to have_content('Most Recent Activity')
      end
    end
  end

  context 'page description' do
    before do
      visit(user_path(user))
    end

    it_behaves_like 'page meta description', 'Lorem ipsum dolor sit amet'
  end

  context 'with a bot user' do
    let(:user) { create(:user, user_type: :security_bot) }

    describe 'feature flag enabled' do
      before do
        stub_feature_flags(security_auto_fix: true)
      end

      it 'only shows Overview and Activity tabs' do
        visit(user_path(user))

        page.within '.nav-links' do
          expect(page).to have_link('Overview')
          expect(page).to have_link('Activity')
          expect(page).not_to have_link('Groups')
          expect(page).not_to have_link('Contributed projects')
          expect(page).not_to have_link('Personal projects')
          expect(page).not_to have_link('Snippets')
        end
      end
    end

    describe 'feature flag disabled' do
      before do
        stub_feature_flags(security_auto_fix: false)
      end

      it 'only shows Overview and Activity tabs' do
        visit(user_path(user))

        page.within '.nav-links' do
          expect(page).to have_link('Overview')
          expect(page).to have_link('Activity')
          expect(page).to have_link('Groups')
          expect(page).to have_link('Contributed projects')
          expect(page).to have_link('Personal projects')
          expect(page).to have_link('Snippets')
        end
      end
    end
  end
end
