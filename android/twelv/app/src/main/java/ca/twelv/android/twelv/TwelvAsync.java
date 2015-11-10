package ca.twelv.android.twelv;

import org.json.JSONObject;

public class TwelvAsync {
    public static abstract class API extends AsyncTaskCallback.TaskCallback {
        private String endpoint;
        private JSONObject params;

        public API(String endpoint, JSONObject params) {
            this.endpoint = endpoint;
            this.params = params;

            new AsyncTaskCallback(this).start();
        }

        public abstract void callback(JSONObject result);

        @Override
        public Object task() {
            return TwelvAPI.request(endpoint, params);
        }

        @Override
        public void callback(Object result) { callback((JSONObject) result); }
    }
}
