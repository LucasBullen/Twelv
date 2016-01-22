package ca.twelv.android.twelv;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.EditText;

public class CreateEventFriends extends Activity{
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_createeventfriends);


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

    public void toLocation(View view){
        Intent createEventLoca = new Intent(this, CreateEventLocation.class);
        Intent intent = getIntent();
        EditText editText = (EditText) findViewById(R.id.editText);
        String eventInfo[] = intent.getStringArrayExtra("title");
        eventInfo[1] = editText.getText().toString();
        createEventLoca.putExtra("friends", eventInfo);
        startActivity(createEventLoca);
    }
}
