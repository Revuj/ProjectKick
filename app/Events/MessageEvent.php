<?php

namespace App\Events;

use App\Message;
use Illuminate\Broadcasting\Channel;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Broadcasting\PrivateChannel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcastNow;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class MessageEvent implements ShouldBroadcastNow
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    public $channel;
    public $message;
    public $photo_path;
    public $username;
    public $date;

    /**
     * Create a new event instance.
     *
     * @return void
     */
    public function __construct($channel, $message, $photo_path, $username, $date)
    {
        $this->channel = $channel;
        $this->message = $message;
        $this->photo_path = $photo_path;
        $this->username = $username;
        $this->date = $date;
    }

    /**
     * Get the channels the event should broadcast on.
     *
     * @return \Illuminate\Broadcasting\Channel|array
     */
    public function broadcastOn()
    {
        return new PrivateChannel('groups.' . $this->channel);
    }

    public function broadcastAs()
    {
        return 'my-event';
    }
}
