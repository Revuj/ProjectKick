<?php

namespace App\Events;

use Illuminate\Broadcasting\Channel;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Broadcasting\PrivateChannel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

/**
 * New notification about a new assignment in a project
 */
class Assignment implements ShouldBroadcast
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    public $issue;
    public $sender;
    public $receiver;
    public $date;
    public $senderPhotoPath;
    public $issueId;

    /**
     * Create a new event instance.
     *
     * @return void
     */
    public function __construct($issue, $sender, $receiver, $date, $senderPhotoPath, $issueId)
    {
        $this->issue = $issue;
        $this->sender = $sender;
        $this->receiver = $receiver;
        $this->date = $date;
        $this->senderPhotoPath = $senderPhotoPath;
        $this->issueId = $issueId;

    }

    /**
     * Get the channels the event should broadcast on.
     *
     * @return \Illuminate\Broadcasting\Channel|array
     */
    public function broadcastOn()
    {
        return new PrivateChannel('assigned.' . $this->receiver);
    }

    public function broadcastAs()
    {
        return 'assignment';
    }
}
