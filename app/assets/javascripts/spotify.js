var spotify_user_token;

$(document).on("turbolinks:load", function() {
  $.ajax({
    url: '/token.json',
    traditional: true,
    dataType: 'json',
    success: function(data) {
      spotify_user_token=data['spotify_token'];

      let _token = spotify_user_token;
      let album = $('.tracks').data('spotify-album-id');

      // Grab tracks
      $.ajax({
       url: "https://api.spotify.com/v1/albums/" + album + "/tracks",
       type: "GET",
       beforeSend: function(xhr){xhr.setRequestHeader('Authorization', 'Bearer ' + _token );},
       success: function(data) { 
         data.items.forEach(function (item, index) {
           $('.tracks').append('<li><a href="#" class="play_song" data-spotify-song-id="'+item.id+'"><strong class="track_name">'+item.name+'</strong> <time>'+msToTime(item.duration_ms)+'</time></a></li>')
         });
       }
      });

      
      // Set up the Web Playback SDK
      window.onSpotifyPlayerAPIReady = () => {
        const player = new Spotify.Player({
          name: 'Droptune',
          getOAuthToken: cb => { cb(_token); }
        });

        // Ready
        player.on('ready', data => {
          // Play a track using our new device ID
          $(document).on('click', '.play_song', function(e){
            e.preventDefault();
            song = $(this).data('spotify-song-id');
            $('.tracks li').removeClass('active');
            $(this).parent('li').addClass('active');
            $(this).removeClass('play_song');
            $(this).addClass('stop_song');
            
            play(data.device_id, song);
          });

          $(document).on('click', '.stop_song', function(e){
            e.preventDefault();
            song = $(this).data('spotify-song-id');
            $('.tracks li').removeClass('active');
            $(this).removeClass('stop_song');
            $(this).addClass('play_song');
            
            player.togglePlay();
          });
        });

        // Connect to the player!
        player.connect();
      }

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
  });

  function msToTime(s) {
    var minutes = Math.floor(s / 60000);
    var seconds = ((s % 60000) / 1000).toFixed(0);
    return minutes + ":" + (seconds < 10 ? '0' : '') + seconds;
  }

});