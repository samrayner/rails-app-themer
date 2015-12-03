require 'rails_helper'

RSpec.describe ThemesController, type: :controller do
  let(:theme) { Theme.create(text_color: 'white') }

  describe 'PUT #update' do
    let(:cache) { double(:cache, fetch: theme, delete: true) }
    let(:params) { { theme: { text_color: 'black' } } }
    let(:action) { put :update, params }

    before do
      allow(Rails).to receive(:cache) { cache }
    end

    it 'clears the cached theme' do
      expect(cache).to receive(:delete).with('theme')
      action
    end

    it 'updates the theme' do
      expect(theme.reload.text_color).to eql('white')
      action
      expect(theme.reload.text_color).to eql('black')
    end

    it 'redirects back to /edit' do
      action
      expect(response).to redirect_to(edit_website_theme_path)
    end

    it 'sets a flash message' do
      action
      expect(flash[:notice]).to eql('Theme updated.')
    end
  end

  describe 'GET #preview' do
    let(:params) { { format: :css, theme: { text_color: 'black' } } }
    let(:action) { patch :preview, params }

    it 'creates a temporary theme' do
      action
      expect(controller.send(:theme)).to be_a_new(Theme)
    end

    it 'returns successfully' do
      action
      expect(response).to be_successful
    end

    it 'renders :show' do
      action
      expect(response).to render_template(:show)
    end
  end
end
