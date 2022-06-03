package com.upshot.flutter_upshot_plugin;

import android.util.Pair;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

public class UpshotEventEmitter {

    private static HashMap<String, List<Pair<EventInterface, Boolean>>> eventListeners = new HashMap<String, List<Pair<EventInterface, Boolean>>>();

    public interface EventInterface {
        void onEvent(String methodName, String payload);
    }

    /**
     * Listen for events for the specified event ID. These events can be emitted with the 'emit' function

     * @param event the event id to listen for
     * @param toAdd the callback function to call
     *              when the event is emitted.
     *              Callback functions must be of
     *              type EventEmitter.EventInterface
     *              and override the desired onEvent overload
     *              </code>
     *
     */
    public void on(String event, EventInterface toAdd) {

        if (!eventListeners.containsKey(event))
            eventListeners.put(event, new ArrayList<>());

        eventListeners.get(event).add(Pair.create(toAdd, false));
    }

    /**
     * Listen for events for the specified event ID. These events can be emitted with the 'emit' function
     * This function is like the <code>.on()</code> function, but it will only be called once, then discarded.
     * @param event the event id to listen for
     * @param toAdd the callback function to call
     *              when the event is emitted.
     *              Callback functions must be of
     *              type EventEmitter.EventInterface
     *              and override the desired onEvent overload
     *              </code>
     *
     */
    public void once(String event, EventInterface toAdd) {

        if (!eventListeners.containsKey(event))
            eventListeners.put(event, new ArrayList<>());

        eventListeners.get(event).add(Pair.create(toAdd, true));
    }

    /**
     * Emit an event to anyone listen to this event id.
     * @param event the event id to emit
     */
//    public void emit(String event)
//    {
//        if (!eventListeners.containsKey(event))
//            return;
//
//        for (Pair<EventInterface, Boolean> ev : eventListeners.get(event))
//            ev.first.onEvent();
//
//        _removeOnces(eventListeners.get(event));
//
//    }

    /**
     * Emit an event to anyone listen to this event id.
     * @param event the event id to emit
     * @param data the String data associated with this event
     */
    public void emit(String event, String data)
    {
        if (!eventListeners.containsKey(event))
            return;

        for (Pair<EventInterface, Boolean> ev : eventListeners.get(event))
            ev.first.onEvent(event, data);

        _removeOnces(eventListeners.get(event));
    }

//    public void emit(String event, byte[] data)
//    {
//        if (!eventListeners.containsKey(event))
//            return;
//
//        for (Pair<EventInterface, Boolean> ev : eventListeners.get(event))
//            ev.first.onEvent(data);
//
//        _removeOnces(eventListeners.get(event));
//    }

//    public void emit(String event, byte[] data, int size)
//    {
//        if (!eventListeners.containsKey(event))
//            return;
//
//        for (Pair<EventInterface, Boolean> ev : eventListeners.get(event))
//            ev.first.onEvent(data, size);
//
//        _removeOnces(eventListeners.get(event));
//    }

    private void _removeOnces(List<Pair<EventInterface, Boolean>> listeners)
    {
        Iterator itr = listeners.iterator();

        while (itr.hasNext())
            if (((Pair<EventInterface, Boolean>)itr.next()).second) //Remove this event from the list if the bool is 'true' (Marked as a once event)
                itr.remove();

    }

    /**
     * Remove all event listeners from this event id.
     * @param event the event id to remove listeners from
     */
    public void off(String event) {

        if (!eventListeners.containsKey(event))
            return;
        eventListeners.get(event).clear();
    }

    /**
     * Remove all event listeners from this emitter.
     */
    public void clearListeners() {

        eventListeners.clear();
    }
}
