/*

 TwelvAPI

 Simple class used to call the api and do various other little
 things.

 Example:

 final Context globalThis = this;
 TwelvAPI.request(globalThis, accessToken, "default", new JSONObject());

 */

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
    // Used to request data from the server. Specify the app context,
    // the access token given by the login process, the specific
    // endpoint that you'd like to request data from, and the params
    // json given to the server
    public static JSONObject request(Context context, AccessToken accessToken, String endpoint, JSONObject paramsObject) {
        // Avoid needing try/catches everytime you call the api
        try {
            // The constructed url string
            String url = context.getString(R.string.api_url) + "?" + endpoint + "=" + paramsObject.toString();
            // Create a useful URL object representing the string url
            URL obj = new URL(url);
            // Required to connect to the internet and send the data to the server
            HttpURLConnection con = (HttpURLConnection) obj.openConnection();

            // Specify there are get variables set
            con.setRequestMethod("GET");
            con.setRequestProperty("User-Agent", "Mozilla/5.0"); //change

            // HTTP response code used for debugging
            int responseCode = con.getResponseCode();

            // Debug info
            Log.d("twelvdebug", "Sending 'GET' request to URL : " + url);
            Log.d("twelvdebug", "Response Code : " + responseCode);

            // Create the appropriate streams in order to read the data
            BufferedReader in = new BufferedReader(
                    new InputStreamReader(con.getInputStream()));
            String inputLine;
            StringBuffer response = new StringBuffer();

            // Read the data while there is still data coming
            while ((inputLine = in.readLine()) != null) {
                response.append(inputLine);
            }

            // Important to close stream after reading all data
            in.close();

            // Debug info
            Log.d("twelvdebug", "Response : " + response.toString());

            // We know the response will be json, so return a parsed json object
            return new JSONObject(response.toString());
        } catch (Exception ex) {
            return jsonError("Error calling api");
        }
    }

    // Useful json error function to use when errors happen if the expected
    // output is json
    private static JSONObject jsonError(String message) {
        try {
            return new JSONObject("{\"error\":\"" + message + "\"}");
        } catch (JSONException e1) {
            return new JSONObject();
        }
    }
}
