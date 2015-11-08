/*

 TwelvAPI

 Simple class used to call the api and do various other little
 things.

 Example:

 final Context globalThis = this;
 TwelvAPI.request(globalThis, accessToken, "default", new JSONObject());

 */

package ca.twelv.android.twelv;

import android.app.Activity;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.Signature;
import android.util.Base64;
import android.util.Log;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class TwelvAPI {
    // Hosted api url
    private static String baseUrl = "localhost/twelv/api/";//"http://lucasbullen.com/twelv/api/";

    // Used to request data from the server. Specify the app context,
    // the specific endpoint that you'd like to request data from,
    // and the params json given to the server
    public static JSONObject request(String endpoint, JSONObject paramsObject) {
        // Avoid needing try/catches everytime you call the api
        try {
            // The constructed url string
            String url = baseUrl + "?" + endpoint + "=";
            url += URLEncoder.encode(paramsObject.toString(), "utf-8");
            Log.d("twelvdebug", "URL : " + url);
            // Create a useful URL object representing the string url
            URL obj = new URL(url);
            // Required to connect to the internet and send the data to the server
            HttpURLConnection con = (HttpURLConnection) obj.openConnection();

            // Specify there are get variables set
            con.setRequestMethod("GET");
            con.setRequestProperty("Content-Type", "text/plain");
            con.setRequestProperty("charset", "utf-8");

            // HTTP response code used for debugging
            int responseCode = con.getResponseCode();

            // Debug info
            Log.d("twelvdebug", "Sending 'GET' request to URL : " + obj.toString());
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

    public static String printKeyHash(Activity context) {
        PackageInfo packageInfo;
        String key = null;
        try {
            //getting application package name, as defined in manifest
            String packageName = context.getApplicationContext().getPackageName();

            //Retriving package info
            packageInfo = context.getPackageManager().getPackageInfo(packageName,
                    PackageManager.GET_SIGNATURES);

            Log.e("Package Name=", context.getApplicationContext().getPackageName());

            for (Signature signature : packageInfo.signatures) {
                MessageDigest md = MessageDigest.getInstance("SHA");
                md.update(signature.toByteArray());
                key = new String(Base64.encode(md.digest(), 0));

                // String key = new String(Base64.encodeBytes(md.digest()));
                Log.e("Key Hash=", key);
            }
        } catch (PackageManager.NameNotFoundException e1) {
            Log.e("Name not found", e1.toString());
        }
        catch (NoSuchAlgorithmException e) {
            Log.e("No such an algorithm", e.toString());
        } catch (Exception e) {
            Log.e("Exception", e.toString());
        }

        Log.d("twelvdebug", "Key : " + key);

        return key;
    }
}
