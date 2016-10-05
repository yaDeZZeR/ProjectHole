
var HOST = "198.211.119.34";

var labels = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
var markers = [];

$(document).on('rails_admin.dom_ready', function(e, content){
    str = "<div class=\"container\"><div id='dp3' class=\"row\"><div class='col-sm-6'><input type='text' class=\"form-control\" id='date-daily'/></div></div></div>";
    $('#user_location_ids_field').after(str + "<div id=\"map\"></div><script async defer  src=\"https://maps.googleapis.com/maps/api/js?key=AIzaSyClOCcW5t-GRBqqAAsUKOeQgi2r8kVBgTg&callback=initMap\"></script>");
});


function initMap() {
  var uluru = {lat: 55.75399399999374, lng: 37.62209300000001};
  var map = new google.maps.Map(document.getElementById('map'), {zoom: 15,center: uluru});
  $('#date-daily').datetimepicker({ format: 'YYYY-MM-DD', defaultDate: new Date()}).on('dp.change', function (ev) {
      getCoord(map, false)
  });
  getCoord(map, true)
  map.controls[google.maps.ControlPosition.TOP_RIGHT].push(
  FullScreenControl(map, "FullScreen",
  "Esc"));
} 

function getCoord(map, isFirst){
  var lineCoordinates = [];

  if (!isFirst) {
    linePath.setMap(null);
    setMapOnAll(null);
    markers = [];
  }

  var request = "http://"+HOST+"/api/v1/locations.json?login=" + 
                  $('#user_login').val() +
                  "&date=" +
                  $('#date-daily').val()

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


function googleMapButton(text, className) {
    "use strict";
    var controlDiv = document.createElement("div");
    controlDiv.className = className;
    controlDiv.index = 1;
    controlDiv.style.padding = "10px";
    // set CSS for the control border.
    var controlUi = document.createElement("div");
    controlUi.style.backgroundColor = "rgb(255, 255, 255)";
    controlUi.style.color = "#565656";
    controlUi.style.cursor = "pointer";
    controlUi.style.textAlign = "center";
    controlUi.style.boxShadow = "rgba(0, 0, 0, 0.298039) 0px 1px 4px -1px";
    controlDiv.appendChild(controlUi);
    // set CSS for the control interior.
    var controlText = document.createElement("div");
    controlText.style.fontFamily = "Roboto,Arial,sans-serif";
    controlText.style.fontSize = "11px";
    controlText.style.paddingTop = "8px";
    controlText.style.paddingBottom = "8px";
    controlText.style.paddingLeft = "8px";
    controlText.style.paddingRight = "8px";
    controlText.innerHTML = text;
    controlUi.appendChild(controlText);
    $(controlUi).on("mouseenter", function () {
        controlUi.style.backgroundColor = "rgb(235, 235, 235)";
        controlUi.style.color = "#000";
    });
    $(controlUi).on("mouseleave", function () {
        controlUi.style.backgroundColor = "rgb(255, 255, 255)";
        controlUi.style.color = "#565656";
    });
    return controlDiv;
}
function FullScreenControl(map, enterFull, exitFull) {
    "use strict";
    if (enterFull === void 0) { enterFull = null; }
    if (exitFull === void 0) { exitFull = null; }
    if (enterFull == null) {
        enterFull = "Full screen";
    }
    if (exitFull == null) {
        exitFull = "Exit full screen";
    }
    var controlDiv = googleMapButton(enterFull, "fullScreen");
    var fullScreen = false;
    var interval;
    var mapDiv = map.getDiv();
    var divStyle = mapDiv.style;
    if (mapDiv.runtimeStyle) {
        divStyle = mapDiv.runtimeStyle;
    }
    var originalPos = divStyle.position;
    var originalWidth = divStyle.width;
    var originalHeight = divStyle.height;
    // ie8 hack
    if (originalWidth === "") {
        originalWidth = mapDiv.style.width;
    }
    if (originalHeight === "") {
        originalHeight = mapDiv.style.height;
    }
    var originalTop = divStyle.top;
    var originalLeft = divStyle.left;
    var originalZIndex = divStyle.zIndex;
    var bodyStyle = document.body.style;
    if (document.body.runtimeStyle) {
        bodyStyle = document.body.runtimeStyle;
    }
    var originalOverflow = bodyStyle.overflow;
    controlDiv.goFullScreen = function () {
        var center = map.getCenter();
        mapDiv.style.position = "fixed";
        mapDiv.style.width = "100%";
        mapDiv.style.height = "100%";
        mapDiv.style.top = "0";
        mapDiv.style.left = "0";
        mapDiv.style.zIndex = "100";
        document.body.style.overflow = "hidden";
        $(controlDiv).find("div div").html(exitFull);
        fullScreen = true;
        google.maps.event.trigger(map, "resize");
        map.setCenter(center);
        // this works around street view causing the map to disappear, which is caused by Google Maps setting the 
        // css position back to relative. There is no event triggered when Street View is shown hence the use of setInterval
        interval = setInterval(function () {
            if (mapDiv.style.position !== "fixed") {
                mapDiv.style.position = "fixed";
                google.maps.event.trigger(map, "resize");
            }
        }, 100);
    };
    controlDiv.exitFullScreen = function () {
        var center = map.getCenter();
        if (originalPos === "") {
            mapDiv.style.position = "relative";
        }
        else {
            mapDiv.style.position = originalPos;
        }
        mapDiv.style.width = originalWidth;
        mapDiv.style.height = originalHeight;
        mapDiv.style.top = originalTop;
        mapDiv.style.left = originalLeft;
        mapDiv.style.zIndex = originalZIndex;
        document.body.style.overflow = originalOverflow;
        $(controlDiv).find("div div").html(enterFull);
        fullScreen = false;
        google.maps.event.trigger(map, "resize");
        map.setCenter(center);
        clearInterval(interval);
    };
    // setup the click event listener
    google.maps.event.addDomListener(controlDiv, "click", function () {
        if (!fullScreen) {
            controlDiv.goFullScreen();
        }
        else {
            controlDiv.exitFullScreen();
        }
    });
    return controlDiv;
}