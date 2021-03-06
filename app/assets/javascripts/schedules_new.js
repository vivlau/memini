var current_fs, next_fs, previous_fs; //fieldsets
var left, opacity, scale; //fieldset properties which we will animate
var animating; //flag to prevent quick multi-click glitches

$(document).ready(function() {
	$('.modal').modal();
	$(".next").click(function(){
		if(animating) return false;
		animating = true;

		current_fs = $(this).parent();
		next_fs = $(this).parent().next();

		//activate next step on progressbar using the index of next_fs
		$("#progressbar li").eq($("fieldset").index(next_fs)).addClass("active");

		//show the next fieldset
		next_fs.show();
		//hide the current fieldset with style
		current_fs.animate({opacity: 0}, {
			step: function(now, mx) {
				//as the opacity of current_fs reduces to 0 - stored in "now"
				//1. scale current_fs down to 80%
				scale = 1 - (1 - now) * 0.2;
				//2. bring next_fs from the right(50%)
				left = (now * 50)+"%";
				//3. increase opacity of next_fs to 1 as it moves in
				opacity = 1 - now;
				current_fs.css({'transform': 'scale('+scale+')'});
				next_fs.css({'left': left, 'opacity': opacity});
			},
			duration: 800,
			complete: function(){
				current_fs.hide();
				animating = false;
			},
			//this comes from the custom easing plugin
			easing: 'easeInOutBack'
		});
	});

	$(".previous").click(function(){
		if(animating) return false;
		animating = true;

		current_fs = $(this).parent();
		previous_fs = $(this).parent().prev();

		//de-activate current step on progressbar
		$("#progressbar li").eq($("fieldset").index(current_fs)).removeClass("active");

		//show the previous fieldset
		previous_fs.show();
		//hide the current fieldset with style
		current_fs.animate({opacity: 0}, {
			step: function(now, mx) {
				//as the opacity of current_fs reduces to 0 - stored in "now"
				//1. scale previous_fs from 80% to 100%
				scale = 0.8 + (1 - now) * 0.2;
				//2. take current_fs to the right(50%) - from 0%
				left = ((1-now) * 50)+"%";
				//3. increase opacity of previous_fs to 1 as it moves in
				opacity = 1 - now;
				current_fs.css({'left': left});
				previous_fs.css({'transform': 'scale('+scale+')', 'opacity': opacity});
			},
			duration: 800,
			complete: function(){
				current_fs.hide();
				animating = false;
			},
			//this comes from the custom easing plugin
			easing: 'easeInOutBack'
		});
	});

	$('#schedule_submit_button').on('click', function(event) {
		// alert('Hellow Vivian, Please Wait...')
		$('#loady_loader').modal('open');
	});

	// const startingDate = $('#start_date').val();
	// const convertStartDate = moment(startingDate, "DD-MMM-YYYY").format('MM-DD-YYYY');
	// const endingDate = $('#end_date').val();
	// const convertEndDate = moment(endingDate, "DD-MMM-YYYY").format('MM-DD-YYYY');
	// const startingTime = $(start_time).val();
	// const convertStartTime = moment(startingTime, "hh:mm a").format('HH:mm:ss');
	// const endingTime = $(end_time).val();
	// const convertEndTime = moment(endingTime, "hh:mm a").format('HH:mm:ss');
	// const startDateTime = convertStartDate + " " + convertStartTime;
	// const endDateTime = convertEndDate + " " + convertEndTime;
	// const makeStartDT = new Date(startDateTime);
	// const makeEndDT = new Date(endDateTime);
	// const startISO = makeStartDT.toISOString();
	// console.log(startISO);
	// const endISO = makeEndDT.toISOString();
	// console.log(endISO);

});
