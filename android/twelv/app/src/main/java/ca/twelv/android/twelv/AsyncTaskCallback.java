/*

 AsyncTaskCallback

 This class is used for making quick threads.
 The constructor takes a TaskCallback object which exists as a
 public subclass to this one. I find it easy to create the
 TaskCallback class inside the constructor.

 Example:

 new TaskCallbackThread(new TaskCallbackThread.TaskCallback() {
    @Override
    public Object task() {
        return "cool";
    }

    @Override
    public void callback(Object result) {
        Log.d("twelvdebug", (String) result);
    }
 }).start();

 This would log "cool"

 */

package ca.twelv.android.twelv;

import android.os.AsyncTask;

public class AsyncTaskCallback {
    // Use to store the constructed callback class
    private TaskCallback taskCallback;

    // Constructor
    public AsyncTaskCallback(TaskCallback taskCallbackParam) {
        taskCallback = taskCallbackParam;
    }

    // Used to start the thread
    public void start() {
        new ExecuteThread().execute(taskCallback);
    }

    // Definition of the class used to store the various callback
    // functions
    public static abstract class TaskCallback {
        // The initial function call
        public abstract Object task();

        // Executed after task finishes with it's return value as
        // result
        public abstract void callback(Object result);
    }

    private static class ExecuteThread extends AsyncTask {
        // Hold the TaskCallback from the constructor
        TaskCallback taskCallback;

        // Executed when the thread begins
        @Override
        protected Object doInBackground(Object[] params) {
            taskCallback = (TaskCallback) params[0];

            return taskCallback.task();
        }

        // Executed when the thread ends, taking the result from
        // the doInBackground function
        @Override
        protected void onPostExecute(Object result) {
            taskCallback.callback(result);
        }
    }
}
