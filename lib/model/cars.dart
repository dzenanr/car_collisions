part of car_collisions;

abstract class Vehicle {
  static const num regularWidth = 75;
  static const num regularHeight = 30;
  static const String regularColorCode = '#ff0000';

  num distanceLimitWidth;
  num distanceLimitHeight;

  num width;
  num height;
  num x;
  num y;
  String colorCode;

  Vehicle(this.distanceLimitWidth, this.distanceLimitHeight) {
    width = regularWidth;
    height = regularHeight;
    colorCode = regularColorCode;
    x = randomNum(distanceLimitWidth - width);
    y = randomNum(distanceLimitHeight - height);
  }
}

class Car extends Vehicle {
  num dx;
  num dy;

  Car(num distanceLimitWidth, num distanceLimitHeight, int speedLimit) :
    super(distanceLimitWidth, distanceLimitHeight) {
    colorCode = randomColorCode();
    dx = randomNum(speedLimit);
    dy = randomNum(speedLimit);
  }

  move(RedCar redCar, Cars cars) {
    x += dx;
    y += dy;
    if (redCar.big) redCar.accident(this);
    for (Car car in cars) {
      if (car != this) {
        car.accident(this);
      }
    }
    if (x > distanceLimitWidth || x < 0) dx = -dx;
    if (y > distanceLimitHeight || y < 0) dy = -dy;
  }

  accident(Car car) {
    if (car.x < x  && car.y < y) {
      if (car.x + car.width >= x && car.y + car.height >= y) {
        dx = -dx; dy = -dy;
        car.dx = -car.dx; car.dy = -car.dy;
      }
    } else if (car.x > x  && car.y < y) {
      if (car.x <= x + width && car.y + car.height >= y) {
        dx = -dx; dy = -dy;
        car.dx = -car.dx; car.dy = -car.dy;
      }
    } else if (car.x < x  && car.y > y) {
      if (car.x + car.width >= x && car.y <= y + height) {
        dx = -dx; dy = -dy;
        car.dx = -car.dx; car.dy = -car.dy;
      }
    } else if (car.x > x  && car.y > y) {
      if (car.x <= x + width && car.y <= y + height) {
        dx = -dx; dy = -dy;
        car.dx = -car.dx; car.dy = -car.dy;
      }
    }
  }
}

class RedCar extends Vehicle {
  static const num smallWidth = 35;
  static const num smallHeight = 14;
  static const String smallColorCode = '#000000';

  bool small = false;
  bool get big => !small;
  bool movable = true;
  bool collision = false;
  int collisionCount = 0;

  RedCar(num distanceLimitWidth, num distanceLimitHeight) :
    super(distanceLimitWidth, distanceLimitHeight);

  bigger() {
    if (small) {
      small = false;
      width = Vehicle.regularWidth;
      height = Vehicle.regularHeight;
      colorCode = Vehicle.regularColorCode;
      collision = false;
      movable = true;
    }
  }

  smaller() {
    if (big) {
      small = true;
      width = smallWidth;
      height = smallHeight;
      colorCode = smallColorCode;
      collision = true;
      collisionCount++;
      movable = false;
    }
  }

  accident(Vehicle car) {
    if (big) {
      if (car.x < x  && car.y < y) {
        if (car.x + car.width >= x && car.y + car.height >= y) smaller();
      } else if (car.x > x  && car.y < y) {
        if (car.x <= x + width && car.y + car.height >= y)     smaller();
      } else if (car.x < x  && car.y > y) {
        if (car.x + car.width >= x && car.y <= y + height)     smaller();
      } else if (car.x > x  && car.y > y) {
        if (car.x <= x + width && car.y <= y + height)         smaller();
      }
    }
  }
}

class Cars {
  RedCar redCar;
  var _carList = new List<Car>();

  Cars(int count, num distanceLimitWidth, num distanceLimitHeight, int speedLimit) {
    redCar = new RedCar(distanceLimitWidth, distanceLimitHeight);
    for (var i = 0; i < count - 1; i++) {
      var car = new Car(distanceLimitWidth, distanceLimitHeight, speedLimit);
      _carList.add(car);
    }
  }

  int get count => _carList.length + 1;

  void add(Car car) {
    _carList.add(car);
  }

  Iterator get iterator => _carList.iterator;
}

