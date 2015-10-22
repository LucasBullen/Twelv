package ca.twelv.android.twelv;

import android.content.Context;
import android.util.Log;

import com.facebook.AccessToken;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

public class TwelvAPI {
    public abstract class apiCallback {
        public abstract void execute(Object params);
    }

    public static JSONObject request(Context context, AccessToken accessToken, String endpoint, JSONObject paramsObject) {
        JSONObject returnObject = new JSONObject();
        final String url = context.getString(R.string.api_url) + "?" + endpoint + "=" + paramsObject.toString();

        try {
            URL obj = new URL(url);
            HttpURLConnection con = (HttpURLConnection) obj.openConnection();

            con.setRequestMethod("GET");
            con.setRequestProperty("User-Agent", "Mozilla/5.0"); //change

            int responseCode = con.getResponseCode();
            Log.d("twelvdebug", "Sending 'GET' request to URL : " + url);
            Log.d("twelvdebug", "Response Code : " + responseCode);

            BufferedReader in = new BufferedReader(
                    new InputStreamReader(con.getInputStream()));
            String inputLine;
            StringBuffer response = new StringBuffer();

            while ((inputLine = in.readLine()) != null) {
                response.append(inputLine);
            }
            in.close();
            Log.d("twelvdebug", "Response : " + response.toString());
            returnObject = new JSONObject(response.toString());

            return returnObject;
        } catch (Exception ex) {
            return jsonError("Error calling api");
        }
    }

    private static JSONObject jsonError(String message) {
        try {
            return new JSONObject("{\"error\":\"" + message + "\"}");
        } catch (JSONException e1) {
            return new JSONObject();
        }
    }
}
