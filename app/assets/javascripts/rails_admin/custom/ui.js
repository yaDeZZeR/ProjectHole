
var labels = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
var markers = [];

$(document).on('rails_admin.dom_ready', function(e, content){
    str = "<div class=\"container\"><div id='dp3' class=\"row\"><div class='col-sm-6'><input type='text' class=\"form-control\" id='date-daily'/></div></div></div>";
    $('#user_location_ids_field').after(str + "<div id=\"map\"></div><script async defer  src=\"https://maps.googleapis.com/maps/api/js?key=AIzaSyClOCcW5t-GRBqqAAsUKOeQgi2r8kVBgTg&callback=initMap\"></script>");
});


function initMap() {
  var uluru = {lat: 55.75399399999374, lng: 37.62209300000001};
  var map = new google.maps.Map(document.getElementById('map'), {zoom: 15,center: uluru});
  getCoord(map, true)
  $('#date-daily').datetimepicker({ format: 'YYYY-MM-DD' }).on('dp.change', function (ev) {
      getCoord(map, false)
  });
} 

function getCoord(map, isFirst){
  var lineCoordinates = [];

  if (isFirst) {
    var request = "http://198.211.119.34/api/v1/locations.json?login=" + 
                    $('#user_login').val();
  } else {
    var request = "http://198.211.119.34/api/v1/locations.json?login=" + 
                  $('#user_login').val() +
                  "&date=" +
                  $('#date-daily').val()
    linePath.setMap(null);
    setMapOnAll(null);
    markers = [];
  }

  $.getJSON( request, function( data ) {
      var response = data.data;
      $(data.data).each(function(index){
          var location = new google.maps.LatLng(response[index].lat, response[index].lng);
          lineCoordinates.push(location)
          var marker = new google.maps.Marker({
            position: location,
            label: labels[index++ % labels.length],
          });
          markers.push(marker);
        });      
      linePath = new google.maps.Polyline({
          path: lineCoordinates,
          geodesic: true,
          strokeColor: '#FF0000',
          strokeOpacity: 1.0,
          strokeWeight: 2
         });   
      linePath.setMap(map);
      setMapOnAll(map);
      map.setCenter(new google.maps.LatLng(response[0].lat, response[0].lng));
  });
  return true;
}

function setMapOnAll(map) {
  for (var i = 0; i < markers.length; i++) {
    markers[i].setMap(map);
  }
}