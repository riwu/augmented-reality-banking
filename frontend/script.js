var floors;
var liftPosition = 4;
var liftDestination;
var numberOfPeopleInLift = 0;
var destinationsHighlighted = [];
var prevCount = 0;

function moveLift() {
  console.log('dest:' + liftDestination.toString() + ' pos:' + liftPosition.toString())
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
  var result = r.responseText.split("\n")
  if (result.length == prevCount) {
    return;
  }
  prevCount = result.length
  var response = JSON.parse(result[result.length - 1]);

  floors = [];
  for (var i = 0; i < Object.keys(response.floor).length; i++) {
    floors[i] = {
      upPressed: response.floor[i].is_up_pressed,
      downPressed: response.floor[i].is_down_pressed,
      peopleCount: response.floor[i].people_count,
      waitTimeUp: response.floor[i].wait_time_up,
      waitTimeDown: response.floor[i].wait_time_down,
    };
  }

  updateButtons();

  liftDestination = response.lift_level;
  numberOfPeopleInLift = response.lift_people_count;

  destinationsHighlighted = response.lift_destinations;
  highlightLifts();
  updateLift();
}

function serialize() {
  obj = {
    floors: {},
  };

  for (var i = 0; i < floors.length; i++) {
    obj.floors[i] = {
      people_count: floors[i].peopleCount,
      is_up_pressed: floors[i].upPressed,
      is_down_pressed: floors[i].downPressed,
    }
  }

  console.log("PARSE:" + JSON.stringify(obj));
}

function updateWaitingTime() {
  for (var i = 0; i < floors.length; i++) {
    $('[data-floor = ' + i + '] > .wait-time-up').text(floors[i].waitTimeUp);
    $('[data-floor = ' + i + '] > .wait-time-down').text(floors[i].waitTimeDown);
  }
}

function updateButtons() {
  for (var i = 0; i < floors.length; i++) {
    if (floors[i].upPressed) {
      $('[data-floor=]' + i + '] > .button-up').addClass('btn-danger');
    }
    if (floors[i].downPressed) {
      $('[data-floor=]' + i + '] > .button-down').addClass('btn-success');
    }
  }
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
      + 'Waiting time to up: <div class="wait-time-up">0</div>'
      + 'Waiting time to down: <div class="wait-time-down">0</div>'
      + '</div>');
  }
  highlightLifts();
  updateWaitingTime();

  $('button').bind('click', function(e) {
    var t = $(e.target);
    if (t.hasClass('button-up')) {
      $(e.target).addClass('btn-danger');
      floors[$(e.target).parent().data('floor')].upPressed = true;
      serialize();
    } else if (t.hasClass('button-down')) {
      $(e.target).addClass('btn-success');
      floors[$(e.target).parent().data('floor')].downPressed = true;
      serialize();
    }
  });

  $('input').change(function(e) {
    serialize();
  });

  updateLift();

  setInterval(function() {
    readData();
    updateWaitingTime();
  }, 500);
});
