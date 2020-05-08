<?php

namespace App\Events;
use App\Project; 
use App\User;

use Illuminate\Broadcasting\Channel;
use Illuminate\Queue\SerializesModels;
use Illuminate\Broadcasting\PrivateChannel;
use Illuminate\Broadcasting\PresenceChannel;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;

class ChatCreated implements ShouldBroadcast
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    public $team; /*represents a group*/

    /**
     * Create a new event instance.
     *
     * @return void
     */
    public function __construct(Project $project)
    {
        $this->team  = $project;
    }

    /**
     * Get the channels the event should broadcast on.
     *
     * @return \Illuminate\Broadcasting\Channel|array
     */
    public function broadcastOn() {
        $channels = [];
        $users = $this->team->memberStatus()->join('user', 'user.id', '=', 'member_status.project_id');


        foreach ($users as $user) {
            array_push($channels, new PrivateChannel('users.' . $user->id));
        }

        return $channels;
    }
}
