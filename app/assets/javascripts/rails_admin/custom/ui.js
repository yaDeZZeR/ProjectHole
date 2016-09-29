
$(document).on('rails_admin.dom_ready', function(e, content){
    $('#user_location_ids_field').after("<div id=\"map\"></div><script async defer  src=\"https://maps.googleapis.com/maps/api/js?key=AIzaSyClOCcW5t-GRBqqAAsUKOeQgi2r8kVBgTg&callback=initMap\"> </script>");
});

function initMap() {
  var uluru = {lat: 55.75399399999374, lng: 37.62209300000001};
  var map = new google.maps.Map(document.getElementById('map'), {zoom: 15,center: uluru});
  var lineCoordinates = [];
 
  $.getJSON( "http://198.211.119.34/api/v1/locations.json?login=" + $('#user_login').val(), function( data ) {
  		var response = data.data;
  		console.log($('#user_login').val())
  		$(data.data).each(function(index){
  			var location = new google.maps.LatLng(response[index].lat, response[index].lng);
  			lineCoordinates.push(location)
  		});

		linePath = new google.maps.Polyline({
		    path: lineCoordinates,
		    geodesic: true,
		    strokeColor: '#FF0000',
		    strokeOpacity: 1.0,
		    strokeWeight: 2
		   });
		linePath.setMap(map);
		map.setCenter(new google.maps.LatLng(response[0].lat, response[0].lng));
	});
} 
