var map, infoWindow;
      function initMap() {
  
  var answer1 = {
    info: '<strong>Answered on July 12th, 2017</strong>',
    lat: 37.7749,
    long: -122.4194
  };

  var answer2 = {
    info: '<strong>Answered on July 13th, 2017</strong>',
    lat: 37.6,
    long: -122
  };

  var answer3 = {
    info: '<strong>Answered on July 12th, 2017</strong>',
    lat: 37.69,
    long: -122.42
  };
  
  var answer4 = {
  info: '<strong>Answered on July 12th, 2017</strong>',
  lat: 37.75,
  long: -122.4
  };

  var locations = [
      [answer1.info, answer1.lat, answer1.long, 0],
      [answer2.info, answer2.lat, answer2.long, 1],
      [answer3.info, answer3.lat, answer3.long, 2],
      [answer4.info, answer4.lat, answer4.long, 3]
    ];

  var map = new google.maps.Map(document.getElementById('map'), {
    zoom: 10,
    center: new google.maps.LatLng(37.7749, -122.4194),
    mapTypeId: google.maps.MapTypeId.ROADMAP
  });

  var infowindow = new google.maps.InfoWindow({});

  var marker, i;

  for (i = 0; i < locations.length; i++) {
    marker = new google.maps.Marker({
      position: new google.maps.LatLng(locations[i][1], locations[i][2]),
      map: map
    });

    google.maps.event.addListener(marker, 'click', (function (marker, i) {
      return function () {
        infowindow.setContent(locations[i][0]);
        infowindow.open(map, marker);
      }
    })(marker, i));
  }
}