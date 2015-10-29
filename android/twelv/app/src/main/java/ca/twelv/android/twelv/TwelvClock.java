package ca.twelv.android.twelv;

import java.sql.Time;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

public class TwelvClock {
    // Stores all events
    private static List<TwelvEvent> events;
    // Used to store important event information
    public static class TwelvEvent {

        private Object name, friends, place;
        private Calendar time;

        public TwelvEvent(Object name, Object friends, Object place, Calendar time) {
                this.name = name;
                this.friends = friends;
                this.place = place;
                this.time = time;
        }
    }

    // returns the position on the clock
    // returns an array with the x cordinate and y coordinate respectively
    public double[] getPos (Calendar time) {
        double hour = time.get(Calendar.HOUR) % 12;
        double min = (double) time.get(Calendar.MINUTE) / 60.0;
        double sec = ((double) time.get(Calendar.SECOND) / 60.0) / 60.0;
        double total = hour + min + sec;

        double x = Math.sin((2 * Math.PI / total));
        double y = Math.cos((2 * Math.PI / total));

        return new double[]{x, y};
    }

    // simplifies method call getPos(Calendar time)
    // ie. getPos(event.time) == getPos(event) instead
    public double[] getPos(TwelvEvent event) {
        return getPos(event.time);
    }

    // Adds an event to the events list
    public static void addEvent(TwelvEvent newEvent) {
        events.add(newEvent);
    }
    // returns position

}
