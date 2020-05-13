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
 * New notification about a new assignment in a project
 */
class Assignment implements  ShouldBroadcast
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    private $message;
    private $type;
    private $id;
    private $project;

    /**
     * Create a new event instance.
     *
     * @return void
     */
    public function __construct($message, $type, $id, $project)
    {
        $this->message = $message;
        $this->type = $type;
        $this->id = $id;
        $this->project = $project;
    }

    /**
     * Get the channels the event should broadcast on.
     *
     * @return \Illuminate\Broadcasting\Channel|array
     */
    public function broadcastOn()
    {
        return new PrivateChannel('assign.' . $this->id);
    }

    public function broadcastAs()
    {
        return 'assign';
    }
}