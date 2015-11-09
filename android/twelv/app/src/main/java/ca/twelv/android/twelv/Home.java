package ca.twelv.android.twelv;

import android.app.Activity;
import android.graphics.Point;
import android.os.Bundle;
import android.view.Display;
import android.view.Menu;
import android.view.MenuItem;
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
        TwelvClock clock = new TwelvClock(this, clockTouchHandler, layout, width, height);
        clock.addEvent(new TwelvClock.TwelvEvent("name", "friends", "place", new GregorianCalendar(2013,1,1,12,30)));
        clock.addEvent(new TwelvClock.TwelvEvent("name", "friends", "place", new GregorianCalendar(2013,1,1,6,30)));
        clock.addEvent(new TwelvClock.TwelvEvent("name", "friends", "place", new GregorianCalendar(2013,1,1,6,0)));
        clock.addEvent(new TwelvClock.TwelvEvent("name", "friends", "place", new GregorianCalendar(2013, 1, 1, 9, 0)));

        setContentView(clock);
        clock.requestFocus();
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
