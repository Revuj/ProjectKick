<?php

namespace App\Policies;

use App\User;
use App\Issue;
use Illuminate\Auth\Access\HandlesAuthorization;

class IssuePolicy
{
    use HandlesAuthorization;


    public function create(User $user, Issue $issue)
    {
        $project_id = $issue->issueList()->select('project_id')->get()->first()->project_id;

        return $user->projectsStatus()->join('project', 'project.id', '=', 'member_status.project_id')
            ->where('project.id', '=', $project_id)
            ->whereNull('departure_date')
            ->exists();
    }

    /**
     * Determine whether the user can update the issue.
     *
     * @param  \App\User  $user
     * @param  \App\Issue  $issue
     * @return mixed
     */
    public function update(User $user, Issue $issue)
    {
        $project_id = $issue->issueList()->select('project_id')->get()->first()->project_id;

        $coordinator = $user->projectsStatus()->join('project', 'project.id', '=', 'member_status.project_id')
            ->where([
                ['role', '=', 'coordinator'],
                ['project.id', '=', $project_id],
            ])
            ->whereNull('departure_date')
            ->exists();

        $author = $issue->author()->select('id')->first()->id === $user->id;
        $assigned = $issue->assignTo()->where('user_id', '=', $user->id)->exists();

        return $coordinator || $author || $assigned;
    }

    /**
     * Determine whether the user can delete the issue.
     *
     * @param  \App\User  $user
     * @param  \App\Issue  $issue
     * @return mixed
     */
    public function delete(User $user, Issue $issue)
    {
        $project_id = $issue->issueList()->select('project_id')->get()->first()->project_id;


        $coordinator = $user->projectsStatus()->join('project', 'project.id', '=', 'member_status.project_id')
            ->where([
                ['role', '=', 'coordinator'],
                ['project.id', '=', $project_id],
            ])
            ->whereNull('departure_date')
            ->exists();

        $author = $issue->author()->id === $user->id;
        $assigned = $issue->assignTo()->where('user_id', '=', $user->id)->exists();

        return $coordinator || $author || $assigned;
    }
}
