## About

I ([@Shpigford](https://twitter.com/Shpigford)) started this project two years ago, let it fall by the wayside, and in that time all the music APIs have changed. So, started from scratch and making it open source from the get go.

## Codebase
The codebase is vanilla Rails, Sidekiq, Puma and Postgres. Quite a simple setup.

## How to start

**1. You'll need to pull down the repo locally.** You can use GitHub's "Clone or download" button to make that happen.

**2. In the command line, you'll want to run the following to set up gems and the database...**
```bash
$ bundle && rake db:setup # Installs the necessary gems and sets up the database
```
**3. You'll need to add a config file** to `config/application.yml` with Twitter and Spotify OAuth keys:
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

**4. Start the server (also in the command line)!**
```bash
$ foreman start # starts webserver and background jobs
```

## Contributing
It's still very early days for this so your mileage will vary here and lots of things will break.

But almost any contribution will be beneficial at this point.

If you've got an improvement, just send in a pull request. If you've got feature ideas, simply [open a new issues](https://github.com/Shpigford/droptune/issues/new)!

## License & Copyright
Released under the MIT license, see the [LICENSE](./LICENSE) file. Copyright (c) 2018 Sabotage Media LLC.
