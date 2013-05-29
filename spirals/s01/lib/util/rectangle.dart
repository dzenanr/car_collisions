part of car_collisions;

roundedCornersRect(CanvasRenderingContext2D context,
    num sx, num sy, num ex, num ey, num r) {
  // based on
  // http://stackoverflow.com/questions/1255512/how-to-draw-a-rounded-rectangle-on-html-canvas

  var r2d = PI/180;

  //ensure that the radius isn't too large for x
  if ((ex - sx) - (2 * r) < 0) {
    r = (( ex - sx ) / 2);
  }
  //ensure that the radius isn't too large for y
  if ((ey - sy) - (2 * r) < 0 ) {
    r = ((ey - sy) / 2 );
  }
  context.moveTo(sx + r, sy);
  context.lineTo(ex - r, sy);
  context.arc(ex - r, sy + r, r, r2d * 270, r2d * 360, false);
  context.lineTo(ex, ey - r);
  context.arc(ex - r, ey - r, r, r2d * 0, r2d * 90, false);
  context.lineTo(sx + r, ey);
  context.arc(sx + r, ey - r, r, r2d * 90, r2d * 180, false);
  context.lineTo(sx, sy + r);
  context.arc(sx + r, sy + r, r, r2d * 180, r2d * 270, false);
}