package ca.twelv.android.twelv;

import android.view.MotionEvent;
import android.view.View;
import android.widget.LinearLayout;

import java.util.ArrayList;

// handles touch events
public class TouchHandler implements View.OnTouchListener {
    private ArrayList<Trail> trails = new ArrayList<Trail>();

    public TouchHandler(LinearLayout layout){
        layout.setOnTouchListener(this);
    }

    // Add/Remove trails for checks
    public void addTrail(Trail trail) { trails.add(trail); }
    public void removeTrail(Trail trail) { trails.remove(trails.indexOf(trail)); }

    @Override
    public boolean onTouch(View v, MotionEvent event) {
        // Leave this comment for debugging touch events
        /* int pointerCount = event.getPointerCount();
        for (int touchIndex = 0; touchIndex < event.getPointerCount(); touchIndex++) {
            int action = event.getActionMasked();
            if (action == MotionEvent.ACTION_UP) Log.d("twelvdebug", "action_up");
            if (action == MotionEvent.ACTION_DOWN) Log.d("twelvdebug", "action_down");
            if (action == MotionEvent.ACTION_MOVE) Log.d("twelvdebug", "action_move");
        }*/

        for (int touchIndex = 0; touchIndex < trails.size(); touchIndex++) {
            trails.get(touchIndex).trackTrail(event);
        }

        return true;
    }

    public static abstract class Trail {
        private Entity start;
        private Entity finish;
        private boolean isStarted;

        // touchIndex saves the index of an event
        public abstract void started(MotionEvent event, int touchIndex);
        public abstract void finished(MotionEvent event, int touchIndex);
        public abstract void moving(MotionEvent event, int touchIndex);
        public abstract void cancelled(MotionEvent event, int touchIndex);

        public Trail(Entity start, Entity finish) {
            this.start = start;
            this.finish = finish;
            this.isStarted = false;
        }

        public void trackTrail(MotionEvent event) {
            int pointerCount = event.getPointerCount();

            for (int touchIndex = 0; touchIndex < pointerCount; touchIndex++) {
                int x = (int) event.getX(touchIndex);
                int y = (int) event.getY(touchIndex);
                int action = event.getActionMasked();

                // touch screen
                if (action == MotionEvent.ACTION_DOWN && isStarted == false && start.isInside(x, y)) {
                    isStarted = true;
                    started(event, touchIndex);
                }
                else if (action == MotionEvent.ACTION_MOVE && isStarted) { // drag
                    moving(event, touchIndex);
                }
                else if (action == MotionEvent.ACTION_UP && isStarted) { // remove touch
                    if (finish.isInside(x, y)) {
                        isStarted = false;
                        finished(event, touchIndex);
                    }
                    else {
                        isStarted = false;
                        cancelled(event, touchIndex);
                    }
                }
            }
        }
    }

    // objects that are touchable
    public static class Entity {
        protected double x, y, rad, width, height;
        protected boolean isSquare;

        // hit box for circles
        public Entity(double x, double y, double rad) {
            this.x = x;
            this.y = y;
            this.rad = rad;
            this.isSquare = false;
        }

        // hit box for squares
        public Entity(int x, int y, int width, int height) {
            this.x = x;
            this.y = y;
            this.width = width;
            this.height = height;
            this.isSquare = true;
        }

        // returns true if user touches inside hit box
        public boolean isInside (double x2, double y2) {
            if (isSquare) {
                if (Math.abs(x - x2) <= this.width / 2.0 &&
                    Math.abs(y - y2) <= this.height / 2.0) {

                    return true;
                }
            } else {
                if (Math.sqrt(Math.pow(x - x2, 2) + Math.pow(y - y2, 2)) <= this.rad) {
                    return true;
                }
            }
            return false;
        }
    }
}
