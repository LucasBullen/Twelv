package ca.twelv.android.twelv;

import android.text.Layout;
import android.view.MotionEvent;
import android.view.View;
import android.widget.LinearLayout;

import java.util.ArrayList;

// handles touch events
public class TouchHandler implements View.OnTouchListener {
    private static ArrayList<Entity> entities = new ArrayList<Entity>();
    private LinearLayout layout;

    public TouchHandler(LinearLayout layout){
        this.layout = layout;
        layout.setOnTouchListener(this);
    }

    @Override
    public boolean onTouch(View v, MotionEvent event) {
        int pointerCount = event.getPointerCount();

        for (int i = 0; i < pointerCount; i++) {
            int x = (int) event.getX(i);
            int y = (int) event.getY(i);

            for (int j = 0; j < TouchHandler.entities.size(); j++) {
                if (TouchHandler.entities.get(j).isInside(x, y)) {
                    // This needs to change based on the mouse event action
                    TouchHandler.entities.get(j).pressed(event);
                }
            }
        }
        return false;
    }

    // objects that are touchable
    public static abstract class Entity {

        private double x, y, rad, width, height;
        private boolean isSquare;

        // hit box for circles
        public Entity(double x, double y, double rad) {
            this.x = x;
            this.y = y;
            this.rad = rad;
            this.isSquare = false; // reduntant but matt likes

            TouchHandler.entities.add(this);
        }

        // hit box for squares
        public Entity(int x, int y, int width, int height) {
            this.x = x;
            this.y = y;
            this.width = width;
            this.height = height;
            this.isSquare = true;

            TouchHandler.entities.add(this);
        }

        public abstract void pressed(MotionEvent event);
        public abstract void released(MotionEvent event);

        // returns true if user touchs inside hit box
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
