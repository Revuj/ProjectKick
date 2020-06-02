<?php

namespace App\Policies;

use App\User;
use App\Project;
use Illuminate\Auth\Access\HandlesAuthorization;

class ProjectPolicy
{
    use HandlesAuthorization;

    public function view(User $user, Project $project)
    {
        return $user->projectsStatus()->join('project', 'project.id', '=', 'member_status.project_id')->exists();
    }

    public function checkActivity(User $user, Project $project)
    {
        return $user->projectsStatus()->join('project', 'project.id', '=', 'member_status.project_id')->exists();
    }

    public function checkMembers(User $user, Project $project)
    {
        return $user->projectsStatus()->join('project', 'project.id', '=', 'member_status.project_id')->exists();
    }

    public function create(User $user)
    {
        return $user->id > 0 && $user->is_admin === false;
    }

    public function delete(User $user, Project $project)
    {
        return $user->projectsStatus()->join('project', 'project.id', '=', 'member_status.project_id')
            ->where('role', '=', 'coordinator')
            ->whereNull('departure_date')
            ->exists();
    }
}
