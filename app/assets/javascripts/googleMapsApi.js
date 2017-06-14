function initMap() {
  var answer1 = {
    info: '<strong>Answered on July 12th, 2017</strong>',
    lat: 37.7749, 
    long: -122.4194
  };

  var length = (gon.answers).length

  var locations = [];

  for (i = 0; i < length; i++) {
    var answer_arr = []
    answer_arr.push("<strong>Answered on July 12th, 2017</strong>");
    answer_arr.push(gon.answers[i].latitude)
    answer_arr.push(gon.answers[i].longitude)
    answer_arr.push(i)
    locations.push(answer_arr)
  }

  var map = new google.maps.Map(document.getElementById('map'), {
    zoom: 5,
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