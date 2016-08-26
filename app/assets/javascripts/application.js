// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require jquery-ui/draggable
//= require jquery-ui/selectable
//= require jquery-ui/droppable
//= require_tree .

function makeChildrenDraggable(el) {
    $(el).find(".draggable").draggable({
      revert: "invalid",
      helper: function(){
        var $copy = $(this).clone();
        console.log($(this))
        $copy.css({ "height": "150px",
                    "width": "150px"})
        return $copy;},
      appendTo: 'body',
      scroll: false
    });
}

$(function() {
  $(".rightColumn").on("click", ".itemButtons", function(){
    $(".content-acd").empty();
    var eventItem = this;
    var request= $.ajax({
      url:"/playlists/" + $(eventItem).attr('id') + "/partial",
      method: "GET",
    });
    request.done(function(tracks){
      $(".content-acd").html(tracks);
      makeChildrenDraggable(".content-acd");
    });
    var request= $.ajax({
      url:"/playlists/" + $(eventItem).attr('id') + "/carousel",
      method: "GET",
    });
    request.done(function(tracks){
      $(".roller").empty();
      $(".roller").html(tracks);
    });
  });
  // $(".rightColumn").on("click", ".draggable", function(){
  makeChildrenDraggable(".rightColumn")
    // $(".draggable").draggable({
    //   revert: "invalid",
    //   helper: function(){
    //     var $copy = $(this).clone();
    //     $copy.css({ "font-size": "21px",
    //                 "font-weight": "200",
    //                 "text-align": "center",
    //                 "width": "200px"})
    //     return $copy;},
    //   appendTo: 'body',
    //   scroll: false
    // });
  // })
  $(".carousel-inner").on("click", ".draggable", function(){
    $(".draggable").draggable({
      revert: "invalid",
      helper: function(){
        var $copy = $(this).clone();
        console.log($(this))
        $copy.css({ "height": "150px",
                    "width": "150px"})
        return $copy;},
      appendTo: 'body',
      scroll: false
    });
  })
  $('.droppable').droppable( {
    tolerance: "touch",
    accept: ".draggable",
    drop: function( event, ui ) {
      var track = $(ui.helper).clone();
      console.log($(track));
      var id = $(track).attr("id")
      console.log(id)
      var request= $.ajax({
        url:"/playlists/track/" + id,
        method: "GET",
      });
      request.done(function(track){
        var div = document.createElement("div");
        $(div).attr("style", "");
        $(div).addClass("eraseable");
        $(div).html(track);
        $('.left-track-container').append(div);
      });

    }
  } );
  $(".track-container").on("click", ".trackButtons", function(){
      var id = $(this).attr("id")
      $(".spotifyPlayer").empty();
      var request= $.ajax({
      url:"/playlists/player/" + id,
      method: "GET",
    });
    request.done(function(response){
      $(".spotifyPlayer").html(response);
    });
  });
  // $('.droppable').droppable( {
  //   tolerance: "touch",
  //   accept: ".draggable",
  //   drop: function( event, ui ) {
  //     var track = $(ui.helper).clone();
  //     track.attr("style", "");
  //     track.addClass("eraseable");
  //     $(this).prepend(track);
  //   }
  // } );
  $(".rightColumn").on("click", ".backTrack", function(){
    $(".content-acd").empty();
    $(".content-acd").append("<p class='header'>Choose A Playlist</p>")
    var request= $.ajax({
      url:"/playlists/partial",
      method: "GET",
    });
    request.done(function(playlists){
      $(".content-acd").append(playlists);
    });

    $("#playlists").show();
  })
  $(".roller").on("click", "div img", function(){
      var id = $(".carousel-indicators .active").attr("id")
      $(".spotifyPlayer").empty();
      var request= $.ajax({
      url:"/playlists/player/" + id,
      method: "GET",
    });
    request.done(function(response){
      $(".spotifyPlayer").html(response);
    });
  });
  $(".centerColumn").on("dblclick", ".eraseable", function(){
    ($(this)).remove();
  })
  $('.sugForm').on("click", ".sugLink", function(event) {
    event.preventDefault();
    var trackIds = $("#suggestion-elements").find("div.trackButtons").map(function() {return this.id}).get();
    var request = $.ajax({
      method: "POST",
      url: "/playlists/temp",
      data: {track_ids: trackIds.toString()}
    })
    request.done(function (tracks) {
      $(".roller").empty();
      $(".roller").html(tracks);
    })
  })
  $(".jumbotron").on("click", ".import-link", function(event) {
    event.preventDefault();
    $(".import-container").empty();
    $(".import-container").html("<h5>Currently Importing Your Playlists.");
    $.ajax({
      url: '/import',
      method: 'POST'
    }).done(function(response) {
      $(".import-container").empty();
      $(".import-container").html("<a href='/playlists'>Continue To Relational Tones!</a>");
    })
  })
});
