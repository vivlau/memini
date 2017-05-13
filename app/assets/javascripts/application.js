// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require moment
//= require fullcalendar
//= require fullcalendar/gcal
//= require_tree .

$(document).ready(function() {
  $('#calendar').fullCalendar({
    Boolean, default: true,
    // Header
    header: {
      left: 'prev,next today',
      center: 'title',
      right: 'month,agendaWeek,agendaDay'
    },
    selectable: true,
    selectHelper: true,
    editable: true,
    dayClick: function (date, jsEvent, view) {
      console.log(date);
      console.log(date.toISOString());
      var clickedDay = date.format();
      // var abc = prompt('Enter Title');
      var starting = `${date.format()}`;
      var ending = `${date.format()}`;
      var newEvent = new Object();
      // newEvent.title = abc;
      newEvent.start = starting;
      newEvent.end = ending;
      newEvent.allDay = false;
      $('#calendar').fullCalendar('renderEvent', newEvent);
    }
  });
});
