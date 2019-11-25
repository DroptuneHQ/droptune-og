apple_music_id= $('#apple-music-authorize');
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
        apple_music_id.show().html('<i class="fab fa-apple"></i> Refresh Apple Music Library').addClass('btn btn-light');


        var album = $('.playback').data('apple-music-album-id');
        if (album){
          console.log(album);
          api_album = music.api.album(album).then(function(item){
            //console.log(item.relationships.tracks.data);  

            item.relationships.tracks.data.forEach(function (item, index) {
              $('.tracks').append('<li>'+item.attributes.name+'</li>')
              //console.log(item, index);
            });
          });
          
          

          music.setQueue({
            album: album
          }).then(function(queue){
            $(".play").on('click', function(e){
              e.preventDefault();
              music.play();
            });

            $(".pause").on('click', function(e){
              e.preventDefault();
              music.pause();
            });

            $(".next").on('click', function(e){
              e.preventDefault();
              music.skipToNextItem();
            });
          });

          $('.playback a').on('click', function(e){
            setTimeout(function() {
                $('.status').text(music.player.nowPlayingItem.attributes['name'])
                console.log(music.player.nowPlayingItem.attributes['name'])
            }, 500);
          });
          

          

        }
        
      }
    }
  });

  apple_music_id.on('click', function () {
    var auth = music.authorize();

    auth.then(function (value) {
        if (music.isAuthorized) {
            apple_music_id.text('Scanning Apple Music Library').prop('disabled', true);
            apple_music_id.addClass('blink');
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

});