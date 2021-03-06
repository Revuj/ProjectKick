<?php

namespace App\Events;

use Illuminate\Broadcasting\Channel;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Broadcasting\PrivateChannel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

/**
 * Kicked out of a project notification
 */
class Meeting implements ShouldBroadcast
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    public $project;
    public $sender;
    public $receiver;
    public $date;
    public $senderPhotoPath;
    public $projectId;
    public $notification;

    /**
     * Create a new event instance.
     *
     * @return void
     */
    public function __construct($project, $sender, $receiver, $date, $senderPhotoPath, $projectId, $notification)
    {
        $this->project = $project;
        $this->sender = $sender;
        $this->receiver = $receiver;
        $this->date = $date;
        $this->senderPhotoPath = $senderPhotoPath;
        $this->projectId = $projectId;
        $this->notification = $notification;
    }

    /**
     * Get the channels the event should broadcast on.
     *
     * @return \Illuminate\Broadcasting\Channel|array
     */
    public function broadcastOn()
    {
        return new PrivateChannel('meeting.' . $this->receiver);
    }

    public function broadcastAs()
    {
        return 'meeting';
    }
}
