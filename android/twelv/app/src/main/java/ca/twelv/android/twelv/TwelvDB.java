package ca.twelv.android.twelv;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

public class TwelvDB extends SQLiteOpenHelper {
    private static final int DB_VERSION = 1;
    private static final String DB_NAME = "twelv";
    private static final String TABLE_EVENTS = "events";

    public TwelvDB(Context context) {
        super(context, DB_NAME, null, DB_VERSION);
    }

    @Override
    public void onCreate(SQLiteDatabase db) {
        db.execSQL(
                "CREATE TABLE " + TABLE_EVENTS + " (" +
                        "eventid bigint(128) PRIMARY KEY, " +
                        "name varchar(128), " +
                        "description varchar(256), " +
                        "starttime datetime, " +
                        "createtime datetime, " +
                        "location varchar(256), " +
                        "pic varchar(256)" +
                ");"
        );
    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        db.execSQL("DROP TABLE IF EXISTS " + TABLE_EVENTS);
        this.onCreate(db);
    }

    public void addEvent(
            int eventid,
            String name,
            String description,
            String starttime,
            String createtime,
            String location,
            String pic) {

        getWritableDatabase().execSQL(
                "INSERT INTO " + TABLE_EVENTS + " (eventid, name, description, starttime, createtime, location, pic) " +
                "VALUES (" +
                        "'" + eventid + "', " +
                        "'" + name + "', " +
                        "'" + description + "', " +
                        "'" + starttime + "', " +
                        "'" + createtime + "', " +
                        "'" + location + "', " +
                        "'" + pic + "'" +
                ");"
        );
    }
}
