package ca.twelv.android.twelv;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.view.MotionEvent;
import android.view.View;
import android.widget.LinearLayout;

import java.util.ArrayList;
import java.util.Calendar;

public class TwelvClock extends View {
    // Stores all events
    private ArrayList<TwelvEvent> events = new ArrayList<TwelvEvent>();
    private int width, height;
    private TouchHandler touchHandler;
    private Paint paint;

    // Test code for adding events START
    private int nx = 0;
    private int ny = 0;
    private TouchHandler.Entity clockEntity;
    // Test code for adding events FINISH

    public TwelvClock(Context context, TouchHandler touchHandler, LinearLayout layout, int width, int height) {
        super(context);
        setFocusable(true);
        setFocusableInTouchMode(true);

        this.touchHandler = touchHandler;
        this.width = width;
        this.height = height;
        this.paint = new Paint();

        this.setOnTouchListener(touchHandler);

        // Test code for adding events START
        this.clockEntity = new TouchHandler.Entity(this.width / 2, this.height / 2, width / 2);

        TouchHandler.Trail addEvent = new TouchHandler.Trail(
                new TouchHandler.Entity(60, this.height - 60, 60),
                clockEntity
        ) {
            @Override
            public void started(MotionEvent event, int touchIndex) { /*Log.d("twelvdebug", "started");*/ }

            @Override
            public void finished(MotionEvent event, int touchIndex) { /*Log.d("twelvdebug", "finished");*/ }

            @Override
            public void moving(MotionEvent event, int touchIndex) {
                //Log.d("twelvdebug", "moving");
                nx = (int) event.getX(touchIndex);
                ny = (int) event.getY(touchIndex);
                invalidate();
            }

            @Override
            public void cancelled(MotionEvent event, int touchIndex) { }
        };

        this.touchHandler.addTrail(addEvent);
        // Test code for adding events FINISH
    }

    @Override
    public void onDraw(Canvas canvas) {
        canvas.drawColor(Color.WHITE);

        int rad = (width - 200) / 2;
        int x = width/2;
        int y = height/2;

        paint.setColor(Color.parseColor("#CD5C5C"));
        canvas.drawCircle(x, y, rad, paint);

        paint.setColor(Color.parseColor("#000000"));

        for (int i = 0; i < events.size(); i++) {
            double[] pos = getPos(events.get(i));

            canvas.drawCircle(x + (int)(pos[0]*rad), y + (int)(pos[1]*rad), 60, paint);
        }

        // Test code for adding events START
        paint.setColor(Color.parseColor("#CD5C5C"));
        canvas.drawCircle(60, height - 60, 60, paint);

        int tx = nx;
        int ty = ny;

        if (clockEntity.isInside(tx, ty)) {
            double gridAngle = 5*Math.PI/180;
            double angle = Math.floor(Math.atan2(ny - height / 2, nx - width / 2)/gridAngle)*gridAngle;

            tx = (int) (Math.cos(angle) * rad) + width / 2;
            ty = (int) (Math.sin(angle) * rad) + height / 2;
        }

        paint.setColor(Color.parseColor("#000000"));
        canvas.drawCircle(tx, ty, 60, paint);
        // Test code for adding events FINISH
    }

    // returns the position on the clock
    // returns an array with the x coordinate and y coordinate
    public static double[] getPos (Calendar time) {
        //double hour = time.get(Calendar.HOUR_OF_DAY) % 12;
        //double min = (double) time.get(Calendar.MINUTE) / 60.0f;
        //double sec = ((double) time.get(Calendar.SECOND) / 60.0) / 60.0;
        double total = (360.0f/12.0f)*( (time.get(Calendar.HOUR) % 12) + time.get(Calendar.MINUTE)/60.0f );// + sec;

        double x = Math.cos(Math.toRadians(total - 90));
        double y = Math.sin(Math.toRadians(total - 90));

        return new double[]{x, y};
    }

    // simplifies method call getPos(Calendar time)
    public static double[] getPos(TwelvEvent event) {
        return getPos(event.time);
    }

    // Adds an event to the events list
    public void addEvent(TwelvEvent newEvent) {
        events.add(newEvent);
    }

    // Used to store important event information
    public static class TwelvEvent {
        private Object name, friends, place;
        public Calendar time;

        public TwelvEvent(Object name, Object friends, Object place, Calendar time) {
            this.name = name;
            this.friends = friends;
            this.place = place;
            this.time = time;
        }
    }

    public abstract class DrawableEntity extends TouchHandler.Entity {
        public DrawableEntity(double x, double y, double rad) {
            super(x, y, rad);
        }

        public DrawableEntity(int x, int y, int width, int height) {
            super(x, y, width, height);
        }

        public abstract void draw(Canvas canvas, Paint paint);
    }

    public abstract class Button extends DrawableEntity {
        public Button(double x, double y, double rad, TouchHandler touchHandler) {
            super(x, y, rad);
            init(touchHandler);
        }

        public Button(int x, int y, int width, int height, TouchHandler touchHandler) {
            super(x, y, width, height);
            init(touchHandler);
        }

        public abstract void action();

        private void init(TouchHandler touchHandler) {
            touchHandler.addTrail(new TouchHandler.Trail(this, this) {
                @Override
                public void started(MotionEvent event, int touchIndex) {}

                @Override
                public void finished(MotionEvent event, int touchIndex) { action(); }

                @Override
                public void moving(MotionEvent event, int touchIndex) {}

                @Override
                public void cancelled(MotionEvent event, int touchIndex) {}
            });
        }

        @Override
        public void draw(Canvas canvas, Paint paint) {
            if (this.isSquare) {
                canvas.drawRect((int)(x + width/2), (int)(y + height/2), (int)(width), (int)(height), paint);
            }
            else {
                canvas.drawCircle((int)(x), (int)(y), (int)(rad), paint);
            }
        }
    }
}
