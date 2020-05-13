<?php

namespace App\Events;

use Illuminate\Broadcasting\Channel;
use Illuminate\Queue\SerializesModels;
use Illuminate\Broadcasting\PrivateChannel;
use Illuminate\Broadcasting\PresenceChannel;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;

/**
 * New notification about an event (personal or meeting)
 */
class EventNotification implements ShouldBroadcast
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    private $message;
    private $type;
    private $id;
    private $event;


    /**
     * Create a new event instance.
     *
     * @return void
     */
    public function __construct($message, $type, $id, $event)
    {
        $this->message = $message;
        $this->type = $type;
        $this->id = $id;
        $this->event = $event;
    }

    /**
     * Get the channels the event should broadcast on.
     *
     * @return \Illuminate\Broadcasting\Channel|array
     */
    public function broadcastOn()
    {
        return new PrivateChannel('eventNotification.' . $this->id);
    }

    public function broadcastAs()
    {
        return 'eventNotification';
    }
}
