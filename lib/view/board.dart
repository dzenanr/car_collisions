part of car_collisions;

class Board {
  static const int CAR_COUNT = 10; // including the red car
  static const int SPEED_LIMIT = 2; // upper limit in random speed

  CanvasElement canvas = query('#canvas');
  CanvasRenderingContext2D context;

  Cars cars;
  RedCar redCar;

  Board() {
    context = canvas.getContext('2d');
    cars = new Cars(CAR_COUNT, canvas.width, canvas.height, SPEED_LIMIT);
    redCar = cars.redCar;
    AudioElement collisionSound = query('#collision-sound');
    LabelElement carCountLabel = query('#car-count');
    carCountLabel.text = cars.count.toString();
    LabelElement collisionCountLabel = query('#collision-count');
    LabelElement messageLabel = query('#message');
    canvas.document.onMouseDown.listen((MouseEvent e) {
      if (redCar.collisionCount < CAR_COUNT) {
        if (redCar.small) redCar.bigger();
      } else messageLabel.text = 'Too many collisions.';
    });
    canvas.document.onMouseMove.listen((MouseEvent e) {
      if (redCar.movable) {
        redCar.x = e.offset.x - Vehicle.WIDTH  / 2;
        redCar.y = e.offset.y - Vehicle.HEIGHT / 2;
        if (redCar.x > canvas.width)  redCar.x = canvas.width - 20;
        if (redCar.x < 0)             redCar.x = 20 - redCar.width;
        if (redCar.y > canvas.height) redCar.y = canvas.height - 20;
        if (redCar.y < 0)             redCar.y = 20 - redCar.height;
      } else if (redCar.collision) {
        collisionSound.play();
        redCar.collision = false;
        var car = new Car(canvas.width, canvas.height, SPEED_LIMIT);
        cars.add(car);
        carCountLabel.text = cars.count.toString();
        collisionCountLabel.text = redCar.collisionCount.toString();
      }
    });
    window.animationFrame.then(gameLoop);
  }

  gameLoop(num delta) {
    displayCars();
    window.animationFrame.then(gameLoop);
  }

  displayCars() {
    clear() {
      context
        ..fillStyle = "#ffffff"
        ..fillRect(0, 0, context.canvas.width, context.canvas.height);
    }

    displayCar(Vehicle car) {
      context
        ..beginPath()
        ..fillStyle = car.colorCode
        ..strokeStyle = 'black'
        ..lineWidth = 2;
      roundedCornersRect(context, car.x, car.y, car.x + car.width,
          car.y + car.height, 10);
      context
        ..fill()
        ..stroke()
        ..closePath();
      // wheels
      context
        ..beginPath()
        ..fillStyle = '#000000'
        ..rect(car.x + 12, car.y - 3, 14, 6)
        ..rect(car.x + car.width - 26, car.y - 3, 14, 6)
        ..rect(car.x + 12, car.y + car.height - 3, 14, 6)
        ..rect(car.x + car.width - 26, car.y + car.height - 3, 14, 6)
        ..fill()
        ..closePath();
    }

    clear();
    for (Car car in cars) {
      car.move(redCar, cars);
      displayCar(car);
    }
    displayCar(redCar);
  }
}