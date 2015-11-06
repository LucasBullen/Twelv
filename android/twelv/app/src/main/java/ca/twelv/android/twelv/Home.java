package ca.twelv.android.twelv;

import android.app.Activity;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Point;
import android.graphics.drawable.BitmapDrawable;
import android.os.Bundle;
import android.util.Log;
import android.view.Display;
import android.view.Menu;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.View;
import android.widget.LinearLayout;

public class Home extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_home);

        // Determine screen dimensions
        Display display = getWindowManager().getDefaultDisplay();
        Point size = new Point();
        display.getSize(size);
        int width = size.x;
        int height = size.y;

        // Init screen buffer and paint object for drawing to it
        Paint paint = new Paint();
        Bitmap bitmapBuffer = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);

        // Init canvas object
        Canvas canvas = new Canvas(bitmapBuffer);

        // test drawing
        paint.setColor(Color.parseColor("#ffffff"));
        canvas.drawRect(0, 0, width, height, paint);

        paint.setColor(Color.parseColor("#CD5C5C"));
        paint.setStyle(Paint.Style.STROKE);
        paint.setStrokeWidth(width/100);
        canvas.drawCircle(width / 2, height/2, width*0.8f/2, paint);

        // Setup layout for drawing
        LinearLayout layout = (LinearLayout) findViewById(R.id.rect);
        layout.setBackgroundDrawable(new BitmapDrawable(bitmapBuffer));

        // Touch listener
        layout.setOnTouchListener(new LinearLayout.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                int pointerCount = event.getPointerCount();

                for (int i = 0; i < pointerCount; i++) {
                    int x = (int) event.getX(i);
                    int y = (int) event.getY(i);
                    int id = event.getPointerId(i);
                    int action = event.getActionMasked();
                    int actionIndex = event.getActionIndex();

                    Log.d("twelvdebug", "Click: " + x + ": " + y);
                }

                return false;
            }
        });
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
