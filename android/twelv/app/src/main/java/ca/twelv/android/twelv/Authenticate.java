package ca.twelv.android.twelv;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;

import com.facebook.AccessToken;
import com.facebook.CallbackManager;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.FacebookSdk;
import com.facebook.login.LoginResult;
import com.facebook.login.widget.LoginButton;

import org.json.JSONException;
import org.json.JSONObject;

public class Authenticate extends Activity {
    LoginButton loginButton;
    CallbackManager callbackManager;

    private void onAccessToken(final AccessToken accessToken) {
        new AsyncTaskCallback(new AsyncTaskCallback.TaskCallback() {
            @Override
            public Object task() {
                JSONObject params = new JSONObject();

                try {
                    params.put("accesstoken", accessToken.getToken());
                    params.put("facebookid", accessToken.getUserId());
                }
                catch (JSONException e) { e.printStackTrace(); }

                return TwelvAPI.request("session_create", params);
            }

            @Override
            public void callback(Object result) {
                Intent homeIntent = new Intent(Authenticate.this, Home.class);
                startActivity(homeIntent);
            }
        }).start();
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        FacebookSdk.sdkInitialize(getApplicationContext());
        setContentView(R.layout.activity_authenticate);

        if (AccessToken.getCurrentAccessToken() == null) {
            // The user is logged out
            callbackManager = CallbackManager.Factory.create();

            loginButton = (LoginButton) findViewById(R.id.login_button);
            loginButton.setReadPermissions("user_friends");
            loginButton.registerCallback(callbackManager, new FacebookCallback<LoginResult>() {
                @Override
                public void onSuccess(LoginResult loginResult) {
                    onAccessToken(loginResult.getAccessToken());
                }

                @Override
                public void onCancel() { }

                @Override
                public void onError(FacebookException e) { Log.d("twelvdebug", e.getMessage()); }
            });
        } else {
            // The user is logged in
            onAccessToken(AccessToken.getCurrentAccessToken());
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_authenticate, menu);
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

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        callbackManager.onActivityResult(requestCode, resultCode, data);
    }
}
