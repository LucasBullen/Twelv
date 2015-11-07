package ca.twelv.android.twelv;

import android.view.MotionEvent;

// handles touch events
public class Touchable {

    // objects that are touchable
    public abstract class Entity {

        private double x, y, rad, width, height;
        private boolean isSquare;

        // hit box for circles
        public Entity(double x, double y, double rad) {
            this.x = x;
            this.y = y;
            this.rad = rad;
            this.isSquare = false; // reduntant but matt likes
        }

        // hit box for squares
        public Entity(int x, int y, int width, int height) {
            this.x = x;
            this.y = y;
            this.width = width;
            this.height = height;
            this.isSquare = true;
        }

        public abstract void pressed(MotionEvent event);
        public abstract void released(MotionEvent event);

        // returns true if inside hit box
        public boolean isInside (double x2, double y2) {

            if (isSquare) {
                if (Math.sqrt(Math.pow(x + x2, 2)) <= width / 2.0 &&
                        Math.sqrt(Math.pow(y + y2, 2)) <= height / 2.0) {
                    return true;
                }
            } else {
                if (Math.sqrt(Math.pow(x + x2, 2) + Math.pow(y - y2, 2)) <= this.rad) {
                    return true;
                }
            }
            return false;
        }

        
    }
}
