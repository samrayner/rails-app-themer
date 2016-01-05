require 'rails_helper'

RSpec.describe ThemesController, type: :controller do
  let(:theme) { Theme.create(text_color: 'white') }

  before do
    allow(controller).to receive(:theme){ theme }
  end

  describe 'GET #show' do
    let(:action) { get :show, format: :css }

    it 'returns successfully' do
      action
      expect(response).to be_successful
    end

    it 'renders :show' do
      action
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #edit' do
    let(:action) { get :edit }

    it 'deletes unused theme images' do
      theme_image = theme.images.create(identifier: 'unused')
      expect(theme.images).to include(theme_image)
      action
      expect(theme.images.reload).not_to include(theme_image)
    end

    it 'returns successfully' do
      action
      expect(response).to be_successful
    end

    it 'renders :edit' do
      action
      expect(response).to render_template(:edit)
    end
  end

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

  describe 'PATCH #preview' do
    let(:params) do
      { format: :css, theme: {
        text_color: 'black', images_attributes: { '0': {
          'identifier': 'logo', 'base64': 'b64'
        }}
      }}
    end
    let(:action) { patch :preview, params }

    it 'updates the theme' do
      action
      expect(controller.send(:theme).text_color).to eql('black')
    end

    it 'stores the image previews' do
      action
      expect(controller.send(:theme).image_previews).to eql({ 'logo' => 'b64' })
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
