part of car_collisions;

abstract class Car {
  static const num regularWidth = 75;
  static const num regularHeight = 30;
  static const String regularColorCode = '#ff0000';
  
  num width;
  num height;
  num distanceLimitWidth;
  num distanceLimitHeight;
  num x;
  num y;
  String colorCode;

  Car(this.distanceLimitWidth, this.distanceLimitHeight) {
    width = regularWidth;
    height = regularHeight;
    colorCode = regularColorCode;
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
    for (NonRedCar car in cars) {
      if (car != this) {
        car.accident(this);
      }
    }
    if (x > distanceLimitWidth || x < 0) dx = -dx;
    if (y > distanceLimitHeight || y < 0) dy = -dy;
  }

  accident(NonRedCar car) {
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
  static const num smallWidth = 35;
  static const num smallHeight = 14;
  static const String smallColorCode = '#000000';

  bool small = false;
  bool get big => !small;
  bool movable = true;

  RedCar(num distanceLimitWidth, num distanceLimitHeight) :
    super(distanceLimitWidth, distanceLimitHeight);

  bigger() {
    if (small) {
      small = false;
      width = 75;
      height = 30;
      colorCode = Car.regularColorCode;
      movable = true;
    }
  }

  smaller(Car car) {
    if (big) {
      small = true;
      width = smallWidth;
      height = smallHeight;
      colorCode = smallColorCode;
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

  int get length => _nonRedCarList.length;

  void add(NonRedCar car) {
    _nonRedCarList.add(car);
  }

  Iterator get iterator => _nonRedCarList.iterator;
}

