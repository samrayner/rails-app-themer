require 'rails_helper'

RSpec.describe Theme, type: :model do
  let(:theme) { Theme.create }

  describe '#color' do
    context 'when var does not exist' do
      it 'returns an invalid CSS value' do
        expect(theme.color(:foo)).to eql(Theme::INVALID_CSS_VALUE)
      end
    end

    context 'when var is not set' do
      before do
        theme.fonts = { text_color: nil }
      end

      it 'returns an invalid CSS value' do
        expect(theme.color(:text)).to eql(Theme::INVALID_CSS_VALUE)
      end
    end

    context 'when var is set' do
      before do
        theme.colors = { text_color: 'bar' }
      end

      it 'returns an invalid CSS value' do
        expect(theme.color(:text)).to eql('bar')
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

      it 'returns an invalid CSS value' do
        expect(theme.font(:body)).to eql('bar')
      end
    end
  end

  describe '#image' do
    context 'when no image has been uploaded' do
      before { theme.logo = nil }

      it 'returns an invalid CSS value' do
        expect(theme.image(:logo)).to eql(Theme::INVALID_CSS_VALUE)
      end
    end

    context 'when an image has been uploaded' do
      before do
        theme.update_column(:logo, 'image.png')
      end

      it 'returns an invalid CSS value' do
        expect(theme.image(:logo)).to eql("/uploads/theme/logo/#{theme.id}/image.png")
      end
    end

    context 'when a base64 version of the image is available' do
      before do
        theme.logo_base64 = 'text'
      end

      it 'returns an invalid CSS value' do
        expect(theme.image(:logo)).to eql('text')
      end
    end
  end

  describe '#image_url' do
    context 'when no image has been uploaded' do
      before { theme.logo = nil }

      it 'returns an invalid CSS value' do
        expect(theme.image_url(:logo)).to eql(Theme::INVALID_CSS_VALUE)
      end
    end

    context 'when an image has been uploaded' do
      before do
        theme.update_column(:logo, 'image.png')
      end

      it 'returns an invalid CSS value' do
        expect(theme.image_url(:logo)).to eql("url(/uploads/theme/logo/#{theme.id}/image.png)")
      end
    end

    context 'when a base64 version of the image is available' do
      before do
        theme.logo_base64 = 'text'
      end

      it 'returns an invalid CSS value' do
        expect(theme.image_url(:logo)).to eql('url(text)')
      end
    end
  end
end
