apple_music_id= $('#apple-music-authorize');
dev_token = 'eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IlhYTEI5WkpSRzMifQ.eyJpc3MiOiJXMzNKWlBQUEZOIiwiaWF0IjoxNTM0NTYwMzAzLCJleHAiOjE1NDc1MjM5MDN9.7Bk5aK9jG-2nDssxGEm4ky3MB4y53i0sqw5e-tjG_wtXlU7fC23k0IOtfizKA79BsDkg6sRMuBSXyoro4XLCFA';

$(document).ready(function() {
  MusicKit.configure({
    developerToken: dev_token,
    app: {
      name: 'Droptune',
      build: '1'
    }
  });

  music = MusicKit.getInstance();

  apple_music_id.on('click', function () {
    var auth = music.authorize();

    auth.then(function (value) {
        if (music.isAuthorized) {
            apple_music_id.text('Scanning iCloud Music Library').prop('disabled', true);
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