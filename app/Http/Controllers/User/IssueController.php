<?php

namespace App\Http\Controllers\User;

use App\Http\Controllers\Controller;
use App\Issue;
use App\IssueList;
use App\Project;
use App\User;
use Illuminate\Http\Request;

class IssueController extends Controller
{
    public function show($id)
    {
        return view('pages.issue');
    }

    public function showList($id)
    {
        $project = Project::find($id);
        if ($project == null) {
            abort(404);
        }

        return view('pages.project.issue-list', ['issueLists' => $project->issueLists()->get(), 'project' => $project]);
    }

    public function showBoard($id)
    {
        $project = Project::find($id);
        if ($project == null) {
            abort(404);
        }

        return view('pages.project.issue-board', ['issueLists' => $project->issueLists()->get(), 'project' => $project]);
    }

    public function showUserIssues($id)
    {
        return view('pages.user-issues');
    }

    public function delete(Request $request, $id)
    {
        $issue = Issue::findOrFail($id);
        $issue->delete();
        return $issue;
    }

    public function create(Request $request)
    {
        $issue = new Issue();
        $issue->name = $request->input('title');
        $issue->author_id = $request->input('author');
        $issue->description = $request->input('description');
        $issue->issue_list_id = $request->input('list');
        $issue->save();
        $user = User::find($issue->author_id);
        return response()->json([$issue, $user]);
    }

    public function addList(Request $request, $id)
    {
        $project = Project::findOrFail($id);

        $issueList = new IssueList();
        $issueList->name = $request->input('name');
        $issueList->project_id = $id;
        $issueList->save();

        return $issueList;
    }

    public function removeList(Request $request, $id)
    {
        $project = Project::findOrFail($id);
        $issueList = IssueList::find($request->input('list'));
        $issueList->delete();

        return $issueList;
    }
}
