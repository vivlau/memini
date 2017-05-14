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
  $('select').material_select();
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
    numberCellHtml: function(row, col, date) {
      var classes;

      if (!this.dayNumbersVisible) { // if there are week numbers but not day numbers
          return '<td/>'; //  will create an empty space above events :(
      }

      classes = this.dayGrid.getDayClasses(date);
      classes.unshift('fc-day-number');

      return '' +
          '<td class="' + classes.join(' ') + '" data-date="' + date.format() + '"><a href ="http://www.google.com">' +
              date.date() +
          '</a></td>';
    },
    dayClick: function (date, jsEvent, view) {
      // $('#modalTitle').html(event.title);
      // $('#modalBody').html(event.description);
      // $('#eventUrl').attr('href',event.url);
      // console.log(date);
      // console.log(date.toISOString());
      // var clickedDay = date.format();
      // // var abc = prompt('Enter Title');
      // var starting = `${date.format()}`;
      // var ending = `${date.format()}`;
      // var newEvent = new Object();
      // // newEvent.title = abc;
      // newEvent.start = starting;
      // newEvent.end = ending;
      // newEvent.allDay = false;
      // $('#calendar').fullCalendar('renderEvent', newEvent);
    }
  });
  // $('.fc-highlight').addClass("modal-trigger");
  // $('.fc-highlight').attr('onclick', "location.href='#modal1'")
  // $('#fullCalModal').modal();
  $('.fc-day-number').each(function() {
    // Get current day
    var day = parseInt($(this).html());
    $(this).html('<a class="modal-trigger" href="#modal1">+</a> ' + day);
    $('#modal1').modal({
       show:true,
       backdrop:'static'
    });
    $('#modal1').modal();
  });
});
