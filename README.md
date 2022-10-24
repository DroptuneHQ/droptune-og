## Archived
This was the original codebase for Droptune, now archived for posterity sake.

## About

Droptune is new music notifications for your favorite artists. It's something I've ([@Shpigford](https://twitter.com/Shpigford)) personally wanted to see exist for as long as I've been listening to music (i.e. forever). I don't passively listen to music. I don't just fire up some radio station or random playlist and listen to whatever is on. I choose what music I listen to and follow artists I love.

In that vein, I always want to know when those artists I love release new music, new music videos, news and whatever else they put out.

Unfortunately, that's a difficult task. I consume content from artists across multiple platforms (Spotify, Apple Music, YouTube, etc). But none of those platform accurately and consistently surface new music. They use fancy algorithms and content editors to surface music they "think" you'll want, instead of just showing it all, ultimately meaning you miss out on a lot.

On top of that, they don't surface the non-audio content (such as news articles and music videos).

So, what Droptune does is centralize all of that. New music, new videos, news and more, all for the artists that I choose to follow, so I never miss beat.

## Codebase

The codebase is vanilla [Rails](https://rubyonrails.org/), [Sidekiq](https://sidekiq.org/) w/ [Redis](https://redis.io/), [Puma](http://puma.io/), [Postgres](https://www.postgresql.org/). Quite a simple setup.

## How to start

**1. You'll need to pull down the repo locally.** You can use GitHub's "Clone or download" button to make that happen.

**2. Then, add a config file** to `config/application.yml`, using `config/application.yml.sample` as your template.

### Twitter

Twitter credentials are needed for authentication. You'll need to have a Developer account and create your own app, which is free: https://developer.twitter.com

Make sure to set the Callback URL to `http://localhost:5000/users/auth/twitter/callback`. You will also need to set a Terms of Service URL, a Privacy Policy URL. Then make sure to check "Request email address" on the permissions page.

### Spotify

For Spotify, you'll also need a Developer account and create your own app, which is also free: https://developer.spotify.com

Make sure to set the Redirect URI to `http://localhost:5000/users/auth/spotify/callback`

These will get you the necessary keys for the app to fully function.

### Apple Music

Apple doesn't make this easy. Actually setting this up isn't necessary for base functionality, but obviously if you'd like the Apple Music portions of this to work, you'll need to set this up. You need an Apple Developer account (which isn't free).

You'll need 3 bits from your Apple Developer account:

- [Private key](https://help.apple.com/developer-account/#/devcdfbb56a3?sub=dev0416b9004)
- [App Key](https://developer.apple.com/account/resources/authkeys/list)
- [Team Key/ID](https://developer.apple.com/account/#/membership/)

### IMVDb

Not required, but necessary to import music video data. Create a free IMVDb developer account here: https://imvdb.com/developers/api

You'll need to register an app and use the generated `Application Key` for `imvdb_key`.

**3. In the command line, you'll then run the following to set up gems and the database...**

```bash
$ bin/setup # Installs the necessary gems and sets up the database
```

**4. Finally, start the server (also in the command line)!**

```bash
$ foreman start # starts webserver and background jobs
```

If you don't already have `foreman` installed, you can install it with `gem install foreman`

## Contributing

It's still very early days for this so your mileage will vary here and lots of things will break.

But almost any contribution will be beneficial at this point.

If you've got an improvement, just send in a pull request. If you've got feature ideas, simply [open a new issues](https://github.com/DroptuneHQ/droptune/issues/new)!

## License & Copyright

Released under the MIT license, see the [LICENSE](./LICENSE) file. Copyright (c) Sabotage Media LLC.
