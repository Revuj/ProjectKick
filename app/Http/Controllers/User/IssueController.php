<?php

namespace App\Http\Controllers\User;

use App\AssignedUser;
use App\Events\Assignment;
use App\Http\Controllers\Controller;
use App\Issue;
use App\IssueList;
use App\IssueTag;
use App\Notification;
use App\NotificationAssign;
use App\Project;
use App\Tag;
use App\User;
use Carbon\Carbon;
use DB;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class IssueController extends Controller
{
    public function show($id)
    {
        DB::beginTransaction();
        $issue = Issue::findOrFail($id);
        $author = User::findOrFail($issue->author_id, ['name', 'id']);
        $tags = $issue->tags()->join('color', 'tag.color_id', '=', 'color.id')->select('name', 'rgb_code', 'tag.id as id')->get();
        $assignedTo = $issue->assignTo()->select('photo_path', 'username', 'id')->get();
        $comments = $issue->comments()
            ->leftjoin('vote', 'vote.comment_id', '=', 'comment.id')
            ->join('user', 'comment.user_id', '=', 'user.id')
            ->selectRaw('comment.*, username, photo_path, coalesce(sum(vote.upvote),0) as total')
            ->groupby('comment.id', 'username', 'photo_path')
            ->orderby('comment.creation_date', 'desc')
            ->get();

        DB::commit();

        $project = $issue->issueList->project->id;

        return view('pages.project.issue', [
            'issue' => $issue,
            'author' => $author,
            'tags' => $tags,
            'users' => $assignedTo,
            'comments' => $comments,
            'project' => $project,
        ]);
    }

    public function showList($id)
    {
        $project = Project::find($id);
        if ($project == null) {
            abort(404);
        }
        $this->authorize('member', $project);

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
        $this->authorize('member', $project);

        return view('pages.project.issue-board', ['issueLists' => $project->issueLists()->get(), 'project' => $project]);
    }

    public function showUserIssues($id)
    {
        $user = User::findOrFail($id);

        $issues = DB::table('assigned_user')->join('user', 'user.id', '=', 'assigned_user.user_id')
            ->join('issue', 'issue.id', '=', 'assigned_user.issue_id')
            ->where('user.id', '=', $id)
            ->select('issue.*')
            ->orderby('creation_date', 'desc')
            ->get();
        return view('pages.user-issues', [
            'issues' => $issues,
            'today' => Carbon::now(),
        ]);
    }

    public function delete(Request $request, $id)
    {
        $issue = Issue::findOrFail($id);
        $this->authorize('delete', $issue);
        $issue->delete();
        return $issue;
    }

    public function create(Request $request)
    {
        $rules = [
            'title' => 'required|string',
            'author' => 'required|integer|exists:user,id',
            'description' => 'string|nullable',
            'list' => 'required|integer|exists:issue_list,id',
        ];

        $messages = [
            'required' => ":attribute is required for the issue. Please choose it",
        ];

        $validator = Validator::make($request->all(), $rules, $messages);
        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors(), 404]);
        }

        $issue = new Issue();
        $issue->name = $request->input('title');
        $issue->author_id = $request->input('author');
        $issue->description = $request->input('description');
        $issue->issue_list_id = $request->input('list');

        $this->authorize('create', $issue);
        $issue->save();
        $user = User::find($issue->author_id);
        return response()->json([$issue, $user]);
    }

    public function addList(Request $request, $id)
    {
        $rules = [
            'name' => 'required|string|min:1',
        ];

        $messages = [
            'name.required' => "Please choose a name for the issue list",
        ];

        $validator = Validator::make($request->all(), $rules, $messages);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors(), 404]);
        }

        $project = Project::findOrFail($id);

        $this->authorize('member', $project);

        $issueList = IssueList::create([
            'name' => $request->input('name'),
            'project_id' => $id,
        ])->refresh();

        return $issueList;
    }

    public function removeList(Request $request, $id)
    {
        $project = Project::findOrFail($id);
        $this->authorize('coordinator', $project);

        $issueList = IssueList::find($request->input('list'));
        $issueList->delete();

        return $issueList;
    }

    public function update(Request $request, $id)
    {
        $issue = Issue::findOrFail($id);

        $request['status'] = filter_var($request['status'], FILTER_VALIDATE_BOOLEAN);

        $rules = [
            'title' => 'string|nullable',
            'description' => 'string|nullable',
            'due_date' => 'date|nullable',
            'status' => 'boolean|nullable',
        ];

        $messages = [
            'required' => ":attribute is required. Please choose it",
        ];

        $validator = Validator::make($request->all(), $rules, $messages);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors(), 404]);
        }

        $this->authorize('update', $issue);

        $title = $request->input("title");
        $description = $request->input("description");
        $dueDate = $request->input("due_date");
        $status = $request->input("status");

        if ($title != null) {
            $issue->name = $title;
        }

        if ($description != null) {
            $issue->description = $description;
        }

        if ($dueDate != null) {
            $issue->due_date = $dueDate;
        }

        if ($status != null) {
            if ($status == true) {
                $issue->is_completed = true;
                $issue->closed_date = Carbon::now()->toDateTimeString();
            } else if ($status == false) {
                $issue->is_completed = false;
            }
        }

        $issue->save();

        return $issue;
    }

    public function assign(Request $request, $id)
    {
        $issue = Issue::findOrFail($id);

        $this->authorize('update', $issue);
        $rules = [
            'user' => 'required|integer|exists:user,id',
            'sender' => 'required|integer|exists:user,id',
            'due_date' => 'date|nullable',
            'status' => 'boolean|nullable',
        ];

        $messages = [
            'required' => ":attribute is required. Please choose it",
        ];

        $validator = Validator::make($request->all(), $rules, $messages);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors(), 404]);
        }

        $user_id = $request->input("user");
        $user = User::findOrFail($user_id);

        $sender_id = $request->input("sender");
        $sender = User::findOrFail($sender_id);

        $assigned_user = AssignedUser::create(['user_id' => $user_id, 'issue_id' => $id]);

        DB::beginTransaction();
        $notification = new Notification();
        $notification->date = Carbon::now()->toDateTimeString();
        $notification->receiver_id = $user_id;
        $notification->sender_id = $sender_id;
        $notification->save();

        $notificationAssign = new NotificationAssign();
        $notificationAssign->notification_id = $notification->id;
        $notificationAssign->issue_id = $id;
        $notificationAssign->save();
        DB::commit();

        $assignment = new Assignment(
            $issue->name,
            $sender->username,
            $user_id,
            Carbon::now()->toDateTimeString(),
            $request->photo_path,
            $id,
            $notification->id,
            $sender->photo_path
        );

        event($assignment);

        return User::findOrFail($user_id);
    }

    public function desassign(Request $request, $id)
    {
        $issue = Issue::findOrFail($id);
        $this->authorize('update', $issue);

        $rules = [
            'user' => 'required|integer|exists:user,id',
        ];

        $messages = [
            'required' => ":attribute is required. Please choose it",
        ];

        $validator = Validator::make($request->all(), $rules, $messages);
        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors(), 404]);
        }

        $user = $request->input("user");
        $assigned_user = AssignedUser::find(['user_id' => intval($user), 'issue_id' => intval($id)]);
        $assigned_user->delete();

        return User::findOrFail($user);
    }

    public function label(Request $request, $id)
    {
        $issue = Issue::findOrFail($id);
        $this->authorize('update', $issue);

        $rules = [
            'label' => 'nullable|integer|exists:tag,id',
            'name' => 'required|string|min:1',
        ];

        $validator = Validator::make($request->all(), $rules);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors(), 404]);
        }

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
        $this->authorize('update', $issue);

        $label = $request->input("label");
        $issue_tag = IssueTag::find(['issue_id' => $id, 'tag_id' => $label]);
        $issue_tag->delete();

        return $issue_tag;
    }

    protected function filter(Request $request, $id)
    {
        $project = Project::findOrFail($id);
        $search = $request->input('search');
        $issues = $project->issues()
            ->whereRaw("issue.search @@ plainto_tsquery('english', ?)", [$search])
            ->select('issue.id');

        return $issues->get();
    }
}
