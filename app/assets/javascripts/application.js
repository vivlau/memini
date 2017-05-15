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
//= require jquery.timepicker.js
//= require Datepair
//= require jquery.datepair.js
//= require bootstrap-datepicker
//= require js-routes
//= require fullcalendar
//= require fullcalendar/gcal
//= require_tree .

$(document).ready(function() {
  // initialize input widgets first
  $('#datepairExample .time').timepicker({
      'showDuration': true,
      'timeFormat': 'g:ia'
  });
  $('#datepairExample .date').datepicker({
      'format': 'yyyy-m-d',
      'autoclose': true
  });
  $('.datepicker').pickadate({
    selectMonths: true, // Creates a dropdown to control month
    selectYears: 15 // Creates a dropdown of 15 years to control year
  });
  // initialize datepair
  $('#datepairExample').datepair();
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
    $(this).html('<a class="modal-trigger" href="#modal1"><i class="tiny material-icons">add</i></a> ' + day);
    $('#modal1').modal({
       show:true,
       backdrop:'static'
    });
    $('#modal1').modal();
  });
  $('#submitButton').on('click', function(e){
    // We don't want this to act as a link so cancel the link action
    e.preventDefault();

    doSubmit();
  });
  function doSubmit(){
    $("#modal1").modal('close');
    console.log($('#event_name').val());
    console.log($('#start_date').val());
    console.log($('#start_time').val());
    console.log($('#end_date').val());
    console.log($('#end_time').val());
    console.log($('#event_location').val());
    console.log($('#event_description').val());
    console.log($('#multCategories').val());
    // DATE TIME CONVERSION
    const startingDate = $('#start_date').val();
    const convertStartDate = moment(startingDate, "DD-MMM-YYYY").format('MM-DD-YYYY');
    const endingDate = $('#end_date').val();
    const convertEndDate = moment(endingDate, "DD-MMM-YYYY").format('MM-DD-YYYY');
    const startingTime = $(start_time).val();
    const convertStartTime = moment(startingTime, "hh:mm a").format('HH:mm:ss');
    const endingTime = $(end_time).val();
    const convertEndTime = moment(endingTime, "hh:mm a").format('HH:mm:ss');
    const startDateTime = convertStartDate + " " + convertStartTime;
    const endDateTime = convertEndDate + " " + convertEndTime;
    const makeStartDT = new Date(startDateTime);
    const makeEndDT = new Date(endDateTime);
    const startISO = makeStartDT.toISOString();
    console.log(startISO);
    const endISO = makeEndDT.toISOString();
    console.log(endISO);
    // EVENT DATA
    const eventData =
      {
          title: $('#event_name').val(),
          start: startISO,
          end: endISO,
          location: $('#event_location').val(),
          description: $('#event_description').val(),
          categories: $('#multCategories').val()
      };
    // ALERT WHEN FORM SUBMITS
    alert("form submitted");
    // RENDER EVENT ONTO CALENDAR
    $("#calendar").fullCalendar('renderEvent', eventData, true);
    $('#calendar').fullCalendar('addEventSource', eventData);
    $('#calendar').fullCalendar('refetchEvents');
    // Resets form on submit
    $("form")[0].reset();
    return false;
  };
});
