# Rails App Themer

<img src="https://raw.githubusercontent.com/samrayner/rails-app-themer/master/app/assets/images/rails-app-themer.png" width="150" />
Sponsored by [Terracoding](http://www.terracoding.com/)

## [Try the live demo][demo]

## Requirements

- Postgres (uses [hstores][]) for storing colors and fonts)
- [Carrierwave][]

## Configuration

To add a color, font or image variable, just add it to `Theme::COLOR_VARS`, `Theme::FONT_VARS` or `Theme::IMAGE_VARS`.

## Theme Template

There are two ways to generate a theme template:

### 1. Automatically (inline styles)

You can include theme style rules in any stylesheet within a `/* THEME ... THEME */` comment block using the `color()`, `font()` and `image_url()` helpers as so:

```
body {
  /* defaults */
  background-color: white;
  color: black;
  font-family: sans-serif;

  /* THEME --------
  background-color: color(background);
  background-image: image_url(background);
  color: color(text);
  font-family: font(body);
  -------- THEME */

  h1, h2, h3, h4, h5, h6 {
    /* defaults */
    font-family: serif;

    /* THEME --------
    font-family: font(headings);
    -------- THEME */
  }
}
```

When you're done editing, **remember to run `rake theme:update`**. It will parse your compiled _application.css_ to generate _app/views/themes/show.css.erb_.

### 2. Manually (separate stylesheet)

Modify [/app/views/themes/show.css.erb][show] by hand. Bear in mind you'll need rules to have higher specificity than those they are overriding. You might want to suffix them with `!important`. Specificity is handled for you if you use the automated method.

## Customisation and Usage

In the example app, the theme can be modified by any user at _/theme/edit_. You'll probably want to add some authentication!

The generated stylesheet is available at _/theme.css_ for inclusion in the `<head>` of any page or via CSS import.

```
<%= stylesheet_link_tag '/theme.css' %>
@import '/theme.css'
```

The database request for the theme values is cached and the controller action will return a `304 Not Modified` status until you modify the theme.

## Theme Defaults

Theme values that haven't been chosen by the user fall back to invalid CSS values so the style rules that use them are ignored. This lets you set default styles anywhere you like to fall back to.

[demo]: http://app-themer.herokuapp.com/theme/edit
[hstores]: http://www.postgresql.org/docs/9.0/static/hstore.html
[Carrierwave]: https://github.com/carrierwaveuploader/carrierwave
[show]: https://github.com/samrayner/rails-app-themer/blob/master/app/views/themes/show.css.erb
