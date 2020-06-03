<?php

namespace App\Policies;

use App\User;
use App\Project;
use Illuminate\Auth\Access\HandlesAuthorization;
use Illuminate\Support\Facades\DB;


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

    public function leave(User $user, Project $project)
    {
        $status = $user->projectsStatus()->join('project', 'project.id', '=', 'member_status.project_id')
            ->where('role', '=', 'developer')
            ->where('project.id', '=', $project->id)
            ->whereNull('departure_date')
            ->exists();

        $coordinators = DB::table('member_status')
            ->join('project', 'project.id', '=', 'member_status.project_id')
            ->where('role', '=', 'coordinator')
            ->where('project.id', '=', $project->id)
            ->whereNull('departure_date');

        return $status || $coordinators->count() > 1;
    }

    public function coordinator(User $user, Project $project)
    {
        return $user->projectsStatus()->join('project', 'project.id', '=', 'member_status.project_id')
            ->where('role', '=', 'coordinator')
            ->where('project.id', '=', $project->id)
            ->whereNull('departure_date')
            ->exists();
    }

    public function member(User $user, Project $project)
    {
        return $user->projectsStatus()->join('project', 'project.id', '=', 'member_status.project_id')
            ->where('project.id', '=', $project->id)
            ->whereNull('departure_date')
            ->exists();
    }
}
