package ca.twelv.android.twelv;

import java.util.Calendar;
import java.util.GregorianCalendar;
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
    public static double[] getPos (Calendar time) {
        //double hour = time.get(Calendar.HOUR_OF_DAY) % 12;
        //double min = (double) time.get(Calendar.MINUTE) / 60.0f;
        //double sec = ((double) time.get(Calendar.SECOND) / 60.0) / 60.0;
        double total = (360.0f/12.0f)*( (time.get(Calendar.HOUR) % 12) + time.get(Calendar.MINUTE)/60.0f );// + sec;

        double x = Math.cos(Math.toRadians(total - 90));
        double y = Math.sin(Math.toRadians(total - 90));

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
