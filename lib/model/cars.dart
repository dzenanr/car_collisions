part of car_collisions;

abstract class Car {
  static const num WIDTH = 75;
  static const num HEIGHT = 30;

  num distanceLimitWidth;
  num distanceLimitHeight;

  num width;
  num height;
  num x;
  num y;
  String colorCode;

  Car(this.distanceLimitWidth, this.distanceLimitHeight) {
    width = WIDTH;
    height = HEIGHT;
    x = randomNum(distanceLimitWidth - width);
    y = randomNum(distanceLimitHeight - height);
  }
}

class NonRedCar extends Car {
  num dx;
  num dy;

  NonRedCar(num distanceLimitWidth, num distanceLimitHeight, int speedLimit) :
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

class RedCar extends Car {
  static const num SMALL_WIDTH = 35;
  static const num SALL_HEIGHT = 14;
  static const String BIG_COLOR_CODE = '#ff0000';
  static const String SMAL_COLOR_CODE = '#000000';

  bool small = false;
  bool get big => !small;
  bool movable = true;
  bool collision = false;
  int collisionCount = 0;

  RedCar(num distanceLimitWidth, num distanceLimitHeight) :
    super(distanceLimitWidth, distanceLimitHeight) {
    colorCode = BIG_COLOR_CODE;
  }

  bigger() {
    if (small) {
      small = false;
      width = Car.WIDTH;
      height = Car.HEIGHT;
      colorCode = BIG_COLOR_CODE;
      collision = false;
      movable = true;
    }
  }

  smaller(Car car) {
    if (big) {
      small = true;
      width = SMALL_WIDTH;
      height = SALL_HEIGHT;
      colorCode = SMAL_COLOR_CODE;
      collision = true;
      collisionCount++;
      movable = false;
    }
  }

  accident(Car car) {
    if (big) {
      if (car.x < x  && car.y < y) {
        if (car.x + car.width >= x && car.y + car.height >= y) smaller(car);
      } else if (car.x > x  && car.y < y) {
        if (car.x <= x + width && car.y + car.height >= y)     smaller(car);
      } else if (car.x < x  && car.y > y) {
        if (car.x + car.width >= x && car.y <= y + height)     smaller(car);
      } else if (car.x > x  && car.y > y) {
        if (car.x <= x + width && car.y <= y + height)         smaller(car);
      }
    }
  }
}

class Cars {
  RedCar redCar;
  var _nonRedCarList = new List<NonRedCar>();

  Cars(int count, num distanceLimitWidth, num distanceLimitHeight, int speedLimit) {
    redCar = new RedCar(distanceLimitWidth, distanceLimitHeight);
    for (var i = 0; i < count - 1; i++) {
      var nonRedCar =
          new NonRedCar(distanceLimitWidth, distanceLimitHeight, speedLimit);
      _nonRedCarList.add(nonRedCar);
    }
  }

  int get count => _nonRedCarList.length + 1;

  void add(NonRedCar car) {
    _nonRedCarList.add(car);
  }

  Iterator get iterator => _nonRedCarList.iterator;
}

