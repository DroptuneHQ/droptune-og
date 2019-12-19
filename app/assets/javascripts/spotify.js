var spotify_user_token;
$(document).on("turbolinks:load", function() {
  window.onSpotifyWebPlaybackSDKReady = () => {}
  $.ajax({
    url: '/token.json',
    traditional: true,
    dataType: 'json',
    success: function(data) {
      spotify_user_token=data['spotify_token'];

      let _token = spotify_user_token;
      let album = $('.details').data('spotify-album-id');

      // Grab tracks
      if (album){
        $.ajax({
         url: "https://api.spotify.com/v1/albums/" + album + "/tracks",
         type: "GET",
         beforeSend: function(xhr){xhr.setRequestHeader('Authorization', 'Bearer ' + _token );},
         success: function(data) { 
           data.items.forEach(function (item, index) {
             $('.spotify_player').append('<li><a href="#" class="play_song" data-spotify-song-id="'+item.id+'"><strong class="track_name">'+item.name+'</strong> <time>'+msToTime(item.duration_ms)+'</time></a></li>')
           });
         }
        });

        // Add to Library
        $('.spotify').on('click', function(e){
            e.preventDefault();

            $.ajax({
              url: "https://api.spotify.com/v1/albums/" + album + "/tracks",
              type: "GET",
              beforeSend: function(xhr){xhr.setRequestHeader('Authorization', 'Bearer ' + _token );},
              success: function(data) {
                var tracks = data.items.map(function(el){ return el.id; }).join(",");
                $.ajax({
                 url: "https://api.spotify.com/v1/me/tracks?ids=" + tracks,
                 type: "PUT",
                 beforeSend: function(xhr){xhr.setRequestHeader('Authorization', 'Bearer ' + _token );},
                 success: function(data) {}
                });
              }
            });

            setTimeout(function(){
              $('.spotify b').text('Added!');
            }, 600);
          })

        // Set up the Web Playback SDK
        const player = new Spotify.Player({
          name: 'Droptune',
          getOAuthToken: cb => { cb(_token); }
        });

        player.on('initialization_error', e => console.error(e));
        player.on('authentication_error', e => console.error(e));
        player.on('account_error', e => console.error(e));
        player.on('playback_error', e => console.error(e));

        // Ready
        player.on('ready', data => {
          // Play a track using our new device ID
          $(document).on('click', '.play_song', function(e){
            e.preventDefault();
            song = $(this).data('spotify-song-id');
            $('.spotify_player li').removeClass('active');
            $(this).parent('li').addClass('active');
            $(this).removeClass('play_song');
            $(this).addClass('stop_song');
            
            play(data.device_id, song);
          });

          $(document).on('click', '.stop_song', function(e){
            e.preventDefault();
            song = $(this).data('spotify-song-id');
            $('.spotify_player li').removeClass('active');
            $(this).removeClass('stop_song');
            $(this).addClass('play_song');
            
            player.togglePlay();
          });
        });

        // Connect to the player!
        player.connect();

        // Play a specified track on the Web Playback SDK's device ID
        function play(device_id, track_id) {
          $.ajax({
           url: "https://api.spotify.com/v1/me/player/play?device_id=" + device_id,
           type: "PUT",
           data: '{"uris": ["spotify:track:'+song+'"]}',
           beforeSend: function(xhr){xhr.setRequestHeader('Authorization', 'Bearer ' + _token );},
           success: function(data) {}
          });
        }

      }

    }
  });

  function msToTime(s) {
    var minutes = Math.floor(s / 60000);
    var seconds = ((s % 60000) / 1000).toFixed(0);
    return minutes + ":" + (seconds < 10 ? '0' : '') + seconds;
  }

});