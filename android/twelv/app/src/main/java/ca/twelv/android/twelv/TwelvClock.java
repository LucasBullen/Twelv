package ca.twelv.android.twelv;

import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.drawable.BitmapDrawable;
import android.widget.LinearLayout;

import java.util.ArrayList;
import java.util.Calendar;

public class TwelvClock {
    // Stores all events
    private ArrayList<TwelvEvent> events = new ArrayList<TwelvEvent>();
    private int width, height;
    private TouchHandler touchHandler;
    private Canvas canvas;
    private Paint paint;
    private Bitmap bitmapBuffer;

    public TwelvClock(TouchHandler touchHandler, LinearLayout layout, int width, int height) {
        this.touchHandler = touchHandler;
        this.width = width;
        this.height = height;

        this.paint = new Paint();
        this.bitmapBuffer = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
        this.canvas = new Canvas(this.bitmapBuffer);

        layout.setBackgroundDrawable(new BitmapDrawable(this.bitmapBuffer));
    }

    public void repaint() {
        canvas.drawColor(Color.WHITE);

        int rad = (width - 200) / 2;
        int x = width/2;
        int y = height/2;

        paint.setColor(Color.parseColor("#CD5C5C"));
        canvas.drawCircle(x, y, rad, paint);

        paint.setColor(Color.parseColor("#000000"));

        for (int i = 0; i < events.size(); i++) {
            double[] pos = getPos(events.get(i));

            canvas.drawCircle(x + (int) pos[0]*rad, y + (int) pos[1]*rad, 60, paint);
        }
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
}
