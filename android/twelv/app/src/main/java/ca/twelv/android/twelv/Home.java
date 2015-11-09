package ca.twelv.android.twelv;

import android.app.Activity;
import android.graphics.Point;
import android.os.Bundle;
import android.util.Log;
import android.view.Display;
import android.view.Menu;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.widget.LinearLayout;

import java.util.GregorianCalendar;

public class Home extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_home);

        // Determine screen dimensions
        Display display = getWindowManager().getDefaultDisplay();
        Point size = new Point();
        display.getSize(size);
        int height = size.y;
        int width = size.x;

        // Setup a TwelvClock object
        LinearLayout layout = (LinearLayout) findViewById(R.id.rect);
        TouchHandler clockTouchHandler = new TouchHandler(layout);
        TwelvClock clock = new TwelvClock(clockTouchHandler, layout, width, height);
        clock.addEvent(new TwelvClock.TwelvEvent("name", "friends", "place", new GregorianCalendar(2013,1,1,12,30)));
        clock.addEvent(new TwelvClock.TwelvEvent("name", "friends", "place", new GregorianCalendar(2013,1,1,6,30)));
        clock.addEvent(new TwelvClock.TwelvEvent("name", "friends", "place", new GregorianCalendar(2013,1,1,6,0)));
        clock.addEvent(new TwelvClock.TwelvEvent("name", "friends", "place", new GregorianCalendar(2013,1,1,9,0)));
        clock.repaint();

        // Test trail
        TouchHandler.Entity myCircle = new TouchHandler.Entity(width/2, height/2, 200);
        TouchHandler.Trail myTrail = new TouchHandler.Trail(myCircle, myCircle) {

            @Override
            public void started(MotionEvent event) {
                Log.d("twelvdebug", "down");
            }

            @Override
            public void finished(MotionEvent event) {
                Log.d("twelvdebug", "up");
            }

            @Override
            public void moving(MotionEvent event) {}
            @Override
            public void cancelled(MotionEvent event) {}
        };

        clockTouchHandler.addTrail(myTrail);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_home, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }
}
