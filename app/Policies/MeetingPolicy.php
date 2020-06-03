<?php

namespace App\Policies;

use App\User;
use App\EventMeeting;
use Illuminate\Auth\Access\HandlesAuthorization;

class MeetingPolicy
{
    use HandlesAuthorization;

    /**
     * Determine whether the user can create event meetings.
     *
     * @param  \App\User  $user
     * @return mixed
     */
    public function create(User $user, EventMeeting $eventMeeting)
    {
        return $user->projectsStatus()->join('project', 'project.id', '=', 'member_status.project_id')
            ->where([
                ['role', '=', 'coordinator'],
                ['project.id', '=', $eventMeeting->project_id],
            ])
            ->whereNull('departure_date')
            ->exists();
    }
}
