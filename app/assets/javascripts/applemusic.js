var dev_token;

$(document).on("turbolinks:load", function() {
  $.ajax({
    url: '/token.json',
    traditional: true,
    dataType: 'json',
    success: function(data) {
      MusicKit.configure({
        developerToken: data['token'],
        app: {
          name: 'Droptune',
          build: '1'
        }
      });
      
      music = MusicKit.getInstance();
      dev_token=data['token'];

      if (music.isAuthorized) {
        $('#apple-music-authorize').show().html('<i class="fab fa-apple"></i> Refresh Apple Music Library').addClass('btn btn-light');
      }

      var album = $('.details').data('apple-music-album-id');
      if (album){
        api_album = music.api.album(album).then(function(item){
          item.relationships.tracks.data.forEach(function (item, index) {
            $('.apple_music_player').append('<li><a href="#" class="play_song" data-apple-music-song-id="'+item.attributes.playParams.id+'"><strong class="track_name">'+item.attributes.name+'</strong> <time>'+msToTime(item.attributes.durationInMillis)+'</time></a></li>')
          });
        });

        $('.apple').on('click', function(e){
          e.preventDefault();
          music.api.addToLibrary({albums: [album]}).then(function(){});

          setTimeout(function(){
            $('.apple b').text('Added!');
          }, 600);
        })

        music.setQueue({
          album: album
        }).then(function(queue){
          $(".apple_music_player .play").on('click', function(e){
            e.preventDefault();
            music.play();
          });

          $(".apple_music_player .pause").on('click', function(e){
            e.preventDefault();
            music.pause();
          });

          $(".apple_music_player .next").on('click', function(e){
            e.preventDefault();
            music.skipToNextItem();
          });
        });
        
        $(document).on('click', '.play_song', function(e){
          e.preventDefault();
          song = $(this).data('apple-music-song-id');
          $('.apple_music_player li').removeClass('active');
          $(this).parent('li').addClass('active');
          $(this).removeClass('play_song');
          $(this).addClass('stop_song');
          
          music.setQueue({
            song: song
          }).then(function(queue){
            music.play();
          });
        });

        $(document).on('click', '.stop_song', function(e){
          e.preventDefault();
          song = $(this).data('apple-music-song-id');
          $('.apple_music_player li').removeClass('active');
          $(this).removeClass('stop_song');
          $(this).addClass('play_song');
          music.setQueue({
            song: song
          }).then(function(queue){
            music.stop();
          });
        });
      }

    }
  });


  $('#apple-music-authorize').on('click', function () {
    var auth = music.authorize();

    auth.then(function (value) {
        if (music.isAuthorized) {
            $('#apple-music-authorize').text('Scanning Apple Music Library').prop('disabled', true);
            $('#apple-music-authorize').addClass('blink');
            importAppleMusic(dev_token, value)
        }
        else {
            // no auth
        }
    });
  });

  function importAppleMusic(devToken, userToken) {
    $.ajax({
      url: '/users/import_apple_music',
      traditional: true,
      dataType: 'json',
      data: {'user_token': userToken, 'dev_token': devToken}
    });
  }

  function msToTime(s) {
    var minutes = Math.floor(s / 60000);
    var seconds = ((s % 60000) / 1000).toFixed(0);
    return minutes + ":" + (seconds < 10 ? '0' : '') + seconds;
  }

});