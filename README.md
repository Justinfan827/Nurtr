# Nurtr
A prototype messaging app for people trying to stay productive! Built using Flutter + Firebase + graphQL

# Feature: lock-timer

Backend feature: 
- Limit messaging to windows: 
- Adding document to user collection:
 timestamp: last-use
lock_duration: # of seconds, 

front_end logic:
if last_use.toseconds + lock_duration < current_time.toseconds() {
    // Then don't allow access to messaging
} else {
    // update last-use = lock_duration + current_time.toseconds().
}

// have timer client-side!

- creating the timer: pushes to firestore the value, in seconds, of the window time set. E.g. if the 
user has opted in to receive messages every minute, this sets the next_available = currentime + 1 minute, 
starting a timer on the client side. While the client is active, this timer is ticking.
    
When messages arrive while the timer isn't 0 and the user is using the app:
    - they are put into a separate collection on firestore for messages. Essentially 'queued' on 
    firestore. 

When the timer hits 0 and the user is active on the app:
    - because the timer has been ticking, hitting 0 triggers a firestore update: everything in the
    queues for each friend is emptied and moved to the messages queue to be shown to users. 


What about when the app is closed? The timer wont tick!

The client keeps track of how long is left in the 'life' of the session. When
the app is closed, the client uses this value to update the next_available time. 

What if the timer hits 0 and the user is not on the app? 

