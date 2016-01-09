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
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.util.Base64;
import android.util.Log;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class TwelvAPI {
    // Hosted api url
    private static String baseUrl = "10.0.2.2/twelv/api/";//"http://lucasbullen.com/twelv/api/";

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

    public static Bitmap getBitmapFromURL(String src) {
        try {
            URL url = new URL(src);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setInstanceFollowRedirects(true);
            //connection.setDoInput(true);
            connection.connect();
            InputStream input = connection.getInputStream();
            Bitmap myBitmap = BitmapFactory.decodeStream(input);

            return myBitmap;
        } catch (IOException e) {
            // Log exception
            return null;
        }
    }

    public static abstract class BitmapFromURL extends AsyncTaskCallback.TaskCallback {
        public abstract void callback(Bitmap bitmap);
        private String source;

        public BitmapFromURL(String source) {
            this.source = source;

            new AsyncTaskCallback(this).start();
        }

        @Override
        public Object task() {
            return TwelvAPI.getBitmapFromURL(source);
        }

        @Override
        public void callback(Object result) {
            this.callback((Bitmap) result);
        }
    }

    public static abstract class BitmapCircleCrop extends AsyncTaskCallback.TaskCallback {
        public abstract void callback(Bitmap bitmap);
        private Bitmap bitmap;
        private double size;

        public BitmapCircleCrop(Bitmap bitmap, int size) {
            this.size = size;
            this.bitmap = Bitmap.createScaledBitmap(bitmap, size, size, true);

            new AsyncTaskCallback(this).start();
        }

        @Override
        public Object task() {
            int width = bitmap.getWidth();
            int height = bitmap.getHeight();

            for (int x = 0; x < width; x++) {
                for (int y = 0; y < height; y++) {
                    if (Math.sqrt(Math.pow(x - size/2, 2) + Math.pow(y - size/2, 2)) > size/2) {
                        bitmap.setPixel(x, y, Color.TRANSPARENT);
                    }
                }
            }

            return bitmap;
        }

        @Override
        public void callback(Object result) {
            this.callback((Bitmap) result);
        }
    }
}
