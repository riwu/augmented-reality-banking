var floors = 5;
var liftPosition = 1;
var liftDestination = 5;

function moveLift() {
	if (liftDestination > liftPosition) {
		setTimeout(goUp, 500);
	} else if (liftDestination < liftPosition) {
		setTimeout(goDown, 500);
	}
}

function goUp() {
	liftPosition++;
	updateLift();
}

function goDown() {
	liftPosition--;
	updateLift();
}

function updateLift() {
	$('.floor').removeClass('active');
	$('[data-floor=' + liftPosition + ']').addClass('active');
	moveLift();
}

function changeLiftDestination(nextFloor) {
	liftDestination = nextFloor;
	updateLift();
}

$(document).ready(function() {
	for (var i = floors; i >= 1; i--) {
		$('#main').append('<div class="floor" data-floor=' + i + '>'
			+ '<div class="floor-number">Floor ' + i + '</div>'
			+ '<div class="lift">10</div>'
			+ '<button class="btn button-up">UP</button>'
			+ '<button class="btn button-down">DOWN</button>'
			+ 'Number of people: <input class="people-count form-control" value="0">'
			+ '</div>');
	}

	$('button').bind('click', function(e) {
		var t = $(e.target);
		if (t.hasClass('button-up')) {
			$(e.target).addClass('btn-danger');
		} else if (t.hasClass('button-down')) {
			$(e.target).addClass('btn-success');
		}
	});

	updateLift();
});
