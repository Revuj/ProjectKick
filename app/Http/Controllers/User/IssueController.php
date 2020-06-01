<?php

namespace App\Http\Controllers\User;

use App\AssignedUser;
use App\Http\Controllers\Controller;
use App\Issue;
use App\IssueList;
use App\IssueTag;
use App\Project;
use App\Tag;
use App\User;
use DB;
use Illuminate\Http\Request;

class IssueController extends Controller
{
    public function show($id)
    {
        DB::beginTransaction();
        $issue = Issue::findOrFail($id);
        $author = User::findOrFail($issue->author_id, ['name', 'id']);
        $tags = $issue->tags()->join('color', 'tag.color_id', '=', 'color.id')->select('name', 'rgb_code')->get();
        $assignedTo = $issue->assignTo()->select('photo_path', 'username', 'id')->get();
        $comments = $issue->comments()
            ->leftjoin('vote', 'vote.comment_id', '=', 'comment.id')
            ->join('user', 'comment.user_id', '=', 'user.id')
            ->selectRaw('comment.*, username, photo_path, coalesce(sum(vote.upvote),0) as total')
            ->groupby('comment.id', 'username', 'photo_path')
            ->orderby('comment.creation_date', 'desc')
            ->get();

        DB::commit();

        return view('pages.project.issue', [
            'issue' => $issue,
            'author' => $author,
            'tags' => $tags,
            'users' => $assignedTo,
            'comments' => $comments,
        ]);
    }

    public function showList($id)
    {
        $project = Project::find($id);
        if ($project == null) {
            abort(404);
        }

        $openIssues = 0;
        $closedIssues = 0;
        foreach ($project->issueLists()->get() as $list) {
            foreach ($list->issues()->get() as $issue) {
                if ($issue->is_completed == true) {
                    $closedIssues++;
                } else {
                    $openIssues++;
                }
            }
        }

        return view('pages.project.issue-list', ['issueLists' => $project->issueLists()->get(), 'project' => $project, 'openIssues' => $openIssues, 'closedIssues' => $closedIssues]);
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

    public function update(Request $request, $id)
    {
        $issue = Issue::findOrFail($id);

        $title = $request->input("title");
        $description = $request->input("description");
        $dueDate = $request->input("due_date");

        if ($title != null) {
            $issue->name = $title;
        }

        if ($description != null) {
            $issue->description = $description;
        }

        if ($dueDate != null) {
            $issue->due_date = $dueDate;
        }

        $issue->save();

        return $issue;
    }

    public function assign(Request $request, $id)
    {
        $issue = Issue::findOrFail($id);

        $user_id = $request->input("user");
        $user = User::findOrFail($user_id);

        $assigned_user = AssignedUser::create(['user_id' => $user_id, 'issue_id' => $id]);

        return User::findOrFail($user_id);
    }

    public function desassign(Request $request, $id)
    {
        $issue = Issue::findOrFail($id);
        $user = $request->input("user");
        $assigned_user = AssignedUser::find(['user_id' => intval($user), 'issue_id' => intval($id)]);
        $assigned_user->delete();

        return User::findOrFail($user);
    }

    public function label(Request $request, $id)
    {
        $issue = Issue::findOrFail($id);
        $label = $request->input("label");
        $name = $request->input("name");
        $tag = null;

        if ($label != null) {
            IssueTag::create(['issue_id' => $id, 'tag_id' => $label]);
            $tag = Tag::findOrFail($label);
        }

        if ($name != null) {
            $tag = Tag::create(['name' => $name, 'color_id' => 1]);
            IssueTag::create(['issue_id' => $id, 'tag_id' => $tag->id]);
        }

        return $tag;
    }

    public function unlabel(Request $request, $id)
    {
        $issue = Issue::findOrFail($id);
        $label = $request->input("label");
        $issue_tag = IssueTag::find(['issue_id' => $id, 'tag_id' => $label]);
        $issue_tag->delete();

        return $issue_tag;
    }
}
