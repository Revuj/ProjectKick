<?php

namespace App\Http\Controllers\User;

use App\Http\Controllers\Controller;
use App\Project;

class IssueController extends Controller
{
    public function show($id)
    {
        return view('pages.issue');
    }

    public function showList($id)
    {
        return view('pages.issue-list');
    }

    public function showBoard($id)
    {
        $project = Project::find($id);
        if ($project == null) {
            abort(404);
        }

        return view('pages.project.issue-board', ['issueLists' => $project->issueLists()->get()]);
    }

    public function showUserIssues($id)
    {
        return view('pages.user-issues');
    }
}
