require 'rails_helper'

RSpec.describe Theme, type: :model do
  let(:theme) { Theme.create }
  let(:theme_image) { theme.images.create(identifier: :logo) }

  describe '#color' do
    context 'when var does not exist' do
      it 'returns an invalid CSS value' do
        expect(theme.color(:foo)).to eql(Theme::INVALID_CSS_VALUE)
      end
    end

    context 'when var is not set' do
      before do
        theme.colors = { text_color: nil }
      end

      it 'returns an invalid CSS value' do
        expect(theme.color(:text)).to eql(Theme::INVALID_CSS_VALUE)
      end
    end

    context 'when var is set' do
      before do
        theme.colors = { text_color: 'bar' }
      end

      it 'returns the value' do
        expect(theme.color(:text)).to eql('bar')
      end
    end
  end

  describe '#rgba' do
    context 'when var does not exist' do
      it 'returns an invalid CSS value' do
        expect(theme.rgba(:foo, 1)).to eql(Theme::INVALID_CSS_VALUE)
      end
    end

    context 'when var is not set' do
      before do
        theme.colors = { text_color: nil }
      end

      it 'returns an invalid CSS value' do
        expect(theme.rgba(:text, 1)).to eql(Theme::INVALID_CSS_VALUE)
      end
    end

    context 'when var is set' do
      before do
        theme.colors = { text_color: '#ff0000' }
      end

      it 'returns the value as RGBa' do
        expect(theme.rgba(:text, 0.5)).to eql('rgba(255, 0, 0, 0.5)')
      end
    end
  end

  describe '#font' do
    context 'when var does not exist' do
      it 'returns an invalid CSS value' do
        expect(theme.font(:foo)).to eql(Theme::INVALID_CSS_VALUE)
      end
    end

    context 'when var is not set' do
      before do
        theme.fonts = { body_font: nil }
      end

      it 'returns an invalid CSS value' do
        expect(theme.font(:body)).to eql(Theme::INVALID_CSS_VALUE)
      end
    end

    context 'when var is set' do
      before do
        theme.fonts = { body_font: 'bar' }
      end

      it 'returns the value' do
        expect(theme.font(:body)).to eql('bar')
      end
    end
  end

  describe '#image' do
    context 'when no image has been uploaded' do
      it 'returns nil' do
        expect(theme.image(:logo)).to be nil
      end
    end

    context 'when an image has been uploaded' do
      before do
        theme_image.update_column(:image, 'image.png')
      end

      it 'returns an invalid CSS value' do
        expect(theme.image(:logo)).to eql("/uploads/theme_image/image/#{theme_image.id}/image.png")
      end
    end

    context 'when a base64 version of the image is available' do
      before do
        theme.image_previews = { 'logo' => 'b64' }
      end

      it 'returns base64 for the image' do
        expect(theme.image(:logo)).to eql('b64')
      end
    end
  end

  describe '#image_url' do
    context 'when no image has been uploaded' do
      it 'returns an invalid CSS value' do
        expect(theme.image_url(:logo)).to eql(Theme::INVALID_CSS_VALUE)
      end
    end

    context 'when an image has been uploaded' do
      before do
        theme_image.update_column(:image, 'image.png')
      end

      it 'returns an invalid CSS value' do
        expect(theme.image_url(:logo)).to eql("url(/uploads/theme_image/image/#{theme_image.id}/image.png)")
      end
    end

    context 'when a base64 version of the image is available' do
      before do
        theme.image_previews = { 'logo' => 'b64' }
      end

      it 'returns base64 for the image' do
        expect(theme.image_url(:logo)).to eql('url(b64)')
      end
    end
  end
end
