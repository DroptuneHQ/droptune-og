## About
Droptune is new music notifications for your favorite artists. It's something I've ([@Shpigford](https://twitter.com/Shpigford)) personally wanted to see exist for as long as I've been listening to music (i.e. forever). I don't passively listen to music. I don't just fire up some radio station or random playlist and listen to whatever is on. I choose what music I listen to and follow artists I love.

In that vein, I always want to know when those artists I love release new music, new music videos, news and whatever else they put out.

Unfortunately, that's a difficult task. I consume content from artists across multiple platforms (Spotify, Apple Music, YouTube, etc). But none of those platform accurately and consistently surface new music. They use fancy algorithms and content editors to surface music they "think" you'll want, instead of just showing it all, ultimately meaning you miss out on a lot.

On top of that, they don't surface the non-audio content (such as news articles and music videos).

So, what Droptune does is centralize all of that. New music, new videos, news and more, all for the artists that I choose to follow, so I never miss beat.

## Design
The design for Droptune is also open source! You can find our more about that as well as learn how to contribute in the [Droptune Design repo](https://github.com/Shpigford/droptune-design)!

## Codebase
The codebase is vanilla Rails, Sidekiq, Puma and Postgres. Quite a simple setup.

## How to start

**1. You'll need to pull down the repo locally.** You can use GitHub's "Clone or download" button to make that happen.

**2. Then, add a config file** to `config/application.yml` with Twitter and Spotify OAuth keys:
```yaml
twitter_key: KEY
twitter_secret: SECRET
spotify_key: KEY
spotify_secret: SECRET
```

For Twitter, you'll need to have a Developer account and create your own app, which is free: https://developer.twitter.com

For Spotify, you'll also need a Developer account and create your own app, which is also free: https://developer.spotify.com

For both, you'll need to set the Redirect/Callback URI to `http://localhost:5000/users/auth/spotify/callback`

These will get you the necessary keys for the app to fully function.

**3. In the command line, you'll then run the following to set up gems and the database...**
```bash
$ bundle && rake db:setup # Installs the necessary gems and sets up the database
```

**4. Finally, start the server (also in the command line)!**
```bash
$ foreman start # starts webserver and background jobs
```

## Contributing
It's still very early days for this so your mileage will vary here and lots of things will break.

But almost any contribution will be beneficial at this point.

If you've got an improvement, just send in a pull request. If you've got feature ideas, simply [open a new issues](https://github.com/Shpigford/droptune/issues/new)!

## License & Copyright
Released under the MIT license, see the [LICENSE](./LICENSE) file. Copyright (c) 2018 Sabotage Media LLC.
