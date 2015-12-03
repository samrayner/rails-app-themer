# Rails App Themer

## Requirements

Postgres (uses [hstores](http://www.postgresql.org/docs/9.0/static/hstore.html) for storing colors and fonts)

## Configuration

To add a color or font variable, just add it to `Theme::COLOR_VARS` or `Theme::FONT_VARS`.

To add an image, add a string column to the database, add the variable to `Theme::IMAGE_VARS`, mount an uploader for [Carrierwave](https://github.com/carrierwaveuploader/carrierwave) and add an accessor for base64 (for live preview of images pre-upload).

```
add_column :themes, :logo, :string

IMAGE_VARS  = [:logo]
mount_uploader :logo, ImageUploader
attr_accessor :logo_base64
```

## Usage

In the example app, the theme can be modified at `/theme/edit`. You'll probably want to add some authentication!

The generated stylesheet is available at `/theme.css`. The database request for the theme values is cached and the controller action will return a `304 Not Modified` status until you modify the theme.

## Theme Defaults

Variables that aren't set fall back to invalid CSS values so the style rules that use them are ignored. This lets you set default styles anywhere you like to fall back to.
