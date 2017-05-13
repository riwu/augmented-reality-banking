var floors;
var liftPosition = 4;
var liftDestination;
var numberOfPeopleInLift = 0;
var destinationsHighlighted = [];

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
	$('.floor > .lift').text('');

	var active = $('[data-floor=' + liftPosition + ']');
	active.addClass('active');
	active.children('.lift').text(numberOfPeopleInLift);
	moveLift();
}

function changeLiftDestination(nextFloor) {
	liftDestination = nextFloor;
	updateLift();
}

function highlightLifts() {
	$('.lift').removeClass('highlighted');
	for (var i = 0; i < destinationsHighlighted.length; i++) {
		$('[data-floor=' + destinationsHighlighted[i] + '] > .lift').addClass('highlighted');
	}
}

function readData() {
	var r = new XMLHttpRequest();
	r.open('GET', '../python.json', false);
	r.send(null);
	var response = JSON.parse(r.responseText);
	
	floors = [];
	for (var i = 0; i < Object.keys(response.floor).length; i++) {
		floors[i] = {
			upPressed: false,
			downPressed: false,
			peopleCount: 0,
		};
	}

	liftDestination = response.lift_level;

	destinationsHighlighted = response.lift_destinations;
}

$(document).ready(function() {
	readData();
	for (var i = floors.length - 1; i >= 0; i--) {
		$('#main').append('<div class="floor" data-floor=' + i + '>'
			+ '<div class="floor-number">Floor ' + i + '</div>'
			+ '<div class="lift"></div>'
			+ '<button class="btn button-up">UP</button>'
			+ '<button class="btn button-down">DOWN</button>'
			+ 'Number of people: <input class="people-count form-control" value="0">'
			+ '</div>');
	}
	highlightLifts();

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
