function initMap() {

  var length = (gon.answers).length
  var locations = [];

  String.prototype.supplant = function (o) {
    return this.replace(/{([^{}]*)}/g,
      function (a, b) {
          var r = o[b];
          return typeof r === 'string' || typeof r === 'number' ? r : a;
      }
    );
  };

  var questionMatch = function(question_id) { 
    var filtered = gon.questions.filter(function(question){
      return question.id === question_id;
    })
    return filtered[0];
  }


  for (i = 0; i < length; i++) {
    var answer_arr = []
    var q = questionMatch(gon.answers[i].question_id);
    answer_arr.push("You answered <strong>'{answer}'</strong> to <strong>{question}</strong> on <strong>{created_at}!</strong>".supplant({
        answer: gon.answers[i].response.toString(), created_at: gon.answers[i].created_at.substr(5, 5), question: "'" + q.title + "'"
      })
    );
    answer_arr.push(gon.answers[i].latitude)
    answer_arr.push(gon.answers[i].longitude)
    answer_arr.push(i)
    locations.push(answer_arr)
  }

  var map = new google.maps.Map(document.getElementById('map'), {
    zoom: 11,
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