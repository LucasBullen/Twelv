package ca.twelv.android.twelv;

import android.os.AsyncTask;

public class TaskCallbackThread {
    private TaskCallback taskCallback;

    public TaskCallbackThread(TaskCallback taskCallbackParam) {
        taskCallback = taskCallbackParam;
    }

    public void start() {
        new ExecuteThread().execute(taskCallback);
    }

    public static abstract class TaskCallback {
        public abstract Object task();
        public abstract void callback(Object result);
    }

    private static class ExecuteThread extends AsyncTask {
        TaskCallback taskCallback;

        @Override
        protected Object doInBackground(Object[] params) {
            taskCallback = (TaskCallback) params[0];

            return taskCallback.task();
        }

        @Override
        protected void onPostExecute(Object result) {
            taskCallback.callback(result);
        }
    }
}
