package ca.twelv.android.twelv;

import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.view.MotionEvent;
import android.view.View;
import android.widget.LinearLayout;

import java.util.ArrayList;
import java.util.Calendar;

public class TwelvClock extends View {
    private final int clockRadius;
    private final int eventRadius;
    private final int strokeWidth;
    private final int swidth, sheight;

    // Stores all events
    private ArrayList<TwelvEvent> events = new ArrayList<TwelvEvent>();
    private TouchHandler touchHandler;
    private Paint paint;

    // Drawables
    private ArrayList<DrawableEntity> drawables = new ArrayList<DrawableEntity>();
    private DrawableEntity clock;
    private DrawableEntity addEventButton;
    private DrawableEntity newEvent;
    private DrawableEntity emptyEvent;

    public TwelvClock(Context context, TouchHandler touchHandler, LinearLayout layout, final int swidth, int sheight) {
        super(context);
        setFocusable(true);
        setFocusableInTouchMode(true);

        this.touchHandler = touchHandler;
        this.paint = new Paint();

        paint.setAntiAlias(true);
        paint.setDither(true);
        paint.setStrokeJoin(Paint.Join.ROUND);
        paint.setStrokeCap(Paint.Cap.ROUND);

        this.swidth = swidth;
        this.sheight = sheight;
        this.clockRadius = (int)(swidth*0.75/2f);
        this.eventRadius = swidth/11;
        this.strokeWidth = swidth/140;

        this.setOnTouchListener(touchHandler);

        // Init drawables
        clock = new DrawableEntity(swidth/2, sheight/2, clockRadius) {
            @Override
            public void draw(Canvas canvas, Paint paint) {
                paint.setColor(Color.parseColor("#000000"));
                paint.setStyle(Paint.Style.STROKE);
                paint.setStrokeWidth(strokeWidth);

                canvas.drawCircle((int) x, (int) y, (int) rad, paint);

                Calendar c = Calendar.getInstance();
                double[] pos = getPos(c);

                canvas.drawLine((float) x, (float) y, (float)(pos[0]*rad*0.8f + x), (float)(pos[1]*rad*0.8f + y), paint);

                paint.setStyle(Paint.Style.FILL);
            }
        };

        addEventButton = new DrawableEntity(100, sheight - 100, 200, 200) {
            @Override
            public void draw(Canvas canvas, Paint paint) {
                paint.setColor(Color.parseColor("#000000"));
                canvas.drawRect((float) (x - width / 2), (float) (y - height / 2), (float) (x + width / 2), (float) (y + height / 2), paint);

                paint.setColor(Color.parseColor("#ffffff"));
                paint.setTextSize(100);
                canvas.drawText("+", (int) x, (int) y, paint);
            }
        };

        newEvent = new DrawableEntity(-1000, -1000, eventRadius) {
            @Override
            public void draw(Canvas canvas, Paint paint) {
                paint.setColor(Color.parseColor("#000000"));
                paint.setStyle(Paint.Style.STROKE);
                paint.setStrokeWidth(strokeWidth);

                canvas.drawCircle((int) x, (int) y, (int) rad, paint);

                paint.setStyle(Paint.Style.FILL);
            }
        };

        // Do not add to drawables
        emptyEvent = new DrawableEntity(0, 0, eventRadius) {
            // create empty bitmap
            private Bitmap image = Bitmap.createBitmap(1, 1, Bitmap.Config.ARGB_8888);

            /*TwelvAPI.BitmapCircleCrop loadImage = new TwelvAPI.BitmapCircleCrop(BitmapFactory.decodeResource(getResources(), R.drawable.temp), eventRadius*2) {
                @Override
                public void callback(Bitmap bitmap) {
                    image = bitmap;
                    invalidate();
                }
            };*/

            TwelvAPI.BitmapFromURL loadImage = new TwelvAPI.BitmapFromURL("https://graph.facebook.com/10206264905515132/picture?type=large") {
                @Override
                public void callback(Bitmap bitmap) {
                    TwelvAPI.BitmapCircleCrop loadImage = new TwelvAPI.BitmapCircleCrop(bitmap, eventRadius*2) {
                        @Override
                        public void callback(Bitmap bitmap) {
                            image = bitmap;
                            invalidate();
                        }
                    };
                }
            };

            @Override
            public void draw(Canvas canvas, Paint paint) {
                paint.setAlpha(254);
                canvas.drawBitmap(image, (int) (x - rad), (int) (y - rad), paint);
                paint.setAlpha(255);

                paint.setColor(Color.parseColor("#000000"));
                paint.setStyle(Paint.Style.STROKE);
                paint.setStrokeWidth(strokeWidth);

                canvas.drawCircle((int) x, (int) y, (int) rad, paint);

                paint.setStyle(Paint.Style.FILL);
            }
        };

        drawables.add(clock);
        drawables.add(addEventButton);
        drawables.add(newEvent);

        // Init trails
        touchHandler.addTrail(new TouchHandler.Trail(addEventButton, clock) {
            @Override
            public void started(MotionEvent event, int touchIndex) { }

            @Override
            public void finished(MotionEvent event, int touchIndex) {
                Intent createEventIntent = new Intent(getContext(), CreateEventTitle.class);
                getContext().startActivity(createEventIntent);

                //cancelled(event, touchIndex);
            }

            @Override
            public void moving(MotionEvent event, int touchIndex) {
                double tx = event.getX(touchIndex);
                double ty = event.getY(touchIndex);

                if (clock.isInside(tx, ty)) {
                    double gridAngle = 5*Math.PI/180;
                    double angle = Math.round(Math.atan2(ty - clock.y, tx - clock.x)/gridAngle)*gridAngle;

                    tx = (Math.cos(angle) * clockRadius) + clock.x;
                    ty = (Math.sin(angle) * clockRadius) + clock.y;
                }

                newEvent.x = tx;
                newEvent.y = ty;

                invalidate();
            }

            @Override
            public void cancelled(MotionEvent event, int touchIndex) {
                newEvent.x = -1000;
                newEvent.y = -1000;
                invalidate();
            }
        });

        invalidate();
    }

    @Override
    public void onDraw(Canvas canvas) {
        canvas.drawColor(Color.WHITE);

        for (int i = 0, len = drawables.size(); i < len; i++) {
            drawables.get(i).draw(canvas, paint);
        }

        for (int i = 0, len = events.size(); i < len; i++) {
            double[] pos = getPos(events.get(i));
            emptyEvent.x = pos[0]*clockRadius + clock.x;
            emptyEvent.y = pos[1]*clockRadius + clock.y;
            emptyEvent.draw(canvas, paint);
        }
    }

    // returns the position on the clock
    // returns an array with the x coordinate and y coordinate
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
    public static double[] getPos(TwelvEvent event) {
        return getPos(event.time);
    }

    // Adds an event to the events list
    public void addEvent(TwelvEvent newEvent) {
        events.add(newEvent);
    }

    // Used to store important event information
    public static class TwelvEvent {
        private Object name, friends, place;
        public Calendar time;

        public TwelvEvent(Object name, Object friends, Object place, Calendar time) {
            this.name = name;
            this.friends = friends;
            this.place = place;
            this.time = time;
        }
    }

    public abstract class DrawableEntity extends TouchHandler.Entity {
        public DrawableEntity(double x, double y, double rad) {
            super(x, y, rad);
        }

        public DrawableEntity(int x, int y, int width, int height) {
            super(x, y, width, height);
        }

        public abstract void draw(Canvas canvas, Paint paint);
    }

    public abstract class Button extends DrawableEntity {
        public Button(double x, double y, double rad, TouchHandler touchHandler) {
            super(x, y, rad);
            init(touchHandler);
        }

        public Button(int x, int y, int width, int height, TouchHandler touchHandler) {
            super(x, y, width, height);
            init(touchHandler);
        }

        public abstract void action();

        private void init(TouchHandler touchHandler) {
            touchHandler.addTrail(new TouchHandler.Trail(this, this) {
                @Override
                public void started(MotionEvent event, int touchIndex) {}

                @Override
                public void finished(MotionEvent event, int touchIndex) { action(); }

                @Override
                public void moving(MotionEvent event, int touchIndex) {}

                @Override
                public void cancelled(MotionEvent event, int touchIndex) {}
            });
        }
    }
}
