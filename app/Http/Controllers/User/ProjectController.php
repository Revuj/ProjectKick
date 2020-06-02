<?php

namespace App\Http\Controllers\User;

use App\Events\Invitation;
use App\Events\KickedOut;
use App\Http\Controllers\Controller;
use App\MemberStatus;
use App\Notification;
use App\NotificationInvite;
use App\NotificationKick;
use App\Project;
use App\User;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class ProjectController extends Controller
{
    public function activity($id)
    {
        // $this->authorize('checkActivity', Project::find($id));

        // creation date
        $project = Project::findOrFail($id, ['id', 'name', 'creation_date', 'author_id', 'description']);
        $project_name = $project['name'];

        //date of creation and closing of issues
        $issues = $project->issues();

        $creation_issues = $issues->join('user', 'user.id', '=', 'author_id')
            ->select('issue.name', 'author_id', 'user.username', 'issue.creation_date as date', 'closed_date', 'issue.id', 'issue.description')
            ->get()->map(function ($issues) {
            $issues['type'] = 'create_issues';
            return $issues;
        });

        $closed_issues = $issues->where('is_completed', '=', 'true')
            ->select('issue.name', 'complete_id', 'closed_date as date', 'user.username', 'issue.description', 'issue.id')
            ->get()->map(function ($issues) {
            $issues['type'] = 'close_issues';
            return $issues;
        });

        // register comments made
        $comments = $issues->join('comment', 'comment.issue_id', '=', 'issue.id')
            ->select('comment.id', 'comment.creation_date as date', 'comment.issue_id', 'comment.user_id', 'issue.name', 'comment.content')
            ->get()->map(function ($comment) {
            $comment['type'] = 'comment';
            $comment['username'] = \App\User::find($comment->user_id)['username'];
            return $comment;
        });

        // channels
        $channels = $project->channels()
            ->select('channel.id', 'name', 'creation_date as date', 'description')->get()->map(function ($channel) {
            $channel['type'] = 'channel';
            return $channel;
        });

        $mergedCollection = $creation_issues->toBase()->merge($closed_issues)->toBase()->merge($comments)->toBase()->merge($channels)->sortbyDesc('date');
        return view('pages.project.activity', [
            'activity' => $mergedCollection,
            'creation_issues' => $creation_issues->sortbyDesc('date'),
            'closed_issues' => $closed_issues->sortByDesc('date'),
            'comments' => $comments->sortByDesc('date'),
            'channels' => $channels->sortByDesc('date'),
            'project' => $project,
            'author' => $project->author()->first(),
        ]);
    }

    public function index($id)
    {
        $project = Project::findOrFail($id);
        // $this->authorize('view', $project);

        $author = User::find($project->author_id);

        $created = new Carbon($project->creation_date);
        $active = true;

        $now = Carbon::now();

        if ($project->finish_date === null) {
            $duration = null;
            $remaing = null;
        } else {
            $finish_date = new Carbon($project->finish_date);
            $duration = $finish_date->diffForHumans($created);

            if ($finish_date->gt($now)) {
                $remaing = $finish_date->diffForHumans($now);
            } else {
                $remaing = 0;
                $active = false;
            }

        }

        $recent_issues = $project->issues()
            ->join('user', 'user.id', '=', 'issue.author_id')
            ->select('issue.id as issue_id', 'issue.name', 'user.id as user_id', 'user.username', 'issue.creation_date')
            ->orderby('issue.creation_date', 'desc')
            ->take(5)
            ->get()->map(function ($issue) use (&$now) {
            $issue['diff_date'] = (new Carbon($issue['creation_date']))->diffForHumans($now) . ' today';
            return $issue;
        });

        $recent_channels = $project->channels()
        ->orderby('channel.creation_date', 'desc')
        ->take(5)
        ->get()->map(function($channel) use(&$now) {
            $channel['diff_date'] = (new Carbon($channel['creation_date']))->diffForHumans($now) .' today';
            return $channel;
        });

        //dd($recent_channels);
        return view('pages.project.overview', [
            'project' => $project,
            'author' => $author,
            'duration' => $duration,
            'remaing' => $remaing,
            'active' => $active,
            'issues' => $recent_issues,
            'channels' => $recent_channels,
        ]);
    }

    public function members($id)
    {
        // verificar se é coordenador para poder remover/convidar
        $project = Project::find($id);
        $this->authorize('checkMembers', $project);

        if ($project == null) {
            abort(404);
        }

        return view('pages.project.members', ["project" => $project]);
    }

    public function create(Request $request)
    {
        $this->authorize('create', new Project());

        $project = new Project();
        $project->name = $request->input('name');
        $project->description = $request->input('description');
        $project->author_id = $request->input('author_id');
        $project->save();

        // trigger para adicionar author aos membros
        return $project;
    }

    public function delete($id)
    {
        $this->authorize('delete', Project::find($id));
        $project = Project::find($id);
        if ($project == null) {
            abort(404);
        }

        $project->delete($id);

        return $project;
    }

    public function update(Request $request, $id)
    {
        // verificar que é coordenador

        $project = Project::find($id);
        if ($project == null) {
            abort(404);
        }

        $title = $request->input("title");
        $description = $request->input("description");

        $project->name = $title;
        $project->description = $description;

        $project->save();

        return $project;
    }

    public function invite(Request $request, $id)
    {
        // verificar que é coordenador

        $project = Project::find($id);
        if ($project == null) {
            abort(404);
        }

        $receiver = $request->input("receiver");
        $role = $request->input("role");
        $user = User::where("username", "=", $receiver)->first();

        // estou a adicionar logo mas no futuro deveria ser um convite
        $membership = new MemberStatus();
        $membership->role = $role;
        $membership->user_id = $user['id'];
        $membership->project_id = $id;
        // $membership->save();

        $user_id = $user['id'];
        $sender_id = $request->input("senderId");

        $event = new Invitation(
            $request->input('projectName'),
            $request->input('senderUsername'),
            $user_id, Carbon::now()->toDateTimeString(),
            $user['photo_path'],
            $id
        );
        event($event);

        DB::beginTransaction();
        $notification = new Notification();
        $notification->date = Carbon::now()->toDateTimeString();
        $notification->receiver_id = $user_id;
        $notification->sender_id = $sender_id;
        $notification->save();

        $notificationKick = new NotificationInvite();
        $notificationKick->notification_id = $notification->id;
        $notificationKick->project_id = $id;
        $notificationKick->save();
        DB::commit();

        return $membership;
    }

    public function remove(Request $request, $id)
    {
        $this->authorize('delete', Project::find($id));
        $project = Project::find($id);
        if ($project == null) {
            abort(404);
        }

        $user_id = $request->input("user");
        $sender_id = $request->input("sender");
        $membership = MemberStatus::where("user_id", "=", $user_id)->where("project_id", "=", $id)->first();
        $membership->delete();

        $event = new KickedOut($request->input('project'), $request->input('username'), $user_id, Carbon::now()->toDateTimeString());
        event($event);

        $notification = new Notification();
        $notification->date = Carbon::now()->toDateTimeString();
        //$notification->description = "";
        $notification->receiver_id = $user_id;
        $notification->sender_id = $sender_id;
        $notification->save();

        $notificationKick = new NotificationKick();
        $notificationKick->notification_id = $notification->id;
        $notificationKick->project_id = $id;
        $notificationKick->save();

        return $membership;
    }

    public function loadMessages(Request $request, $id)
    {

        $rules = [
            'page' => 'required|numeric|min:1',
        ];

        $validator = Validator::make($request->all(), $rules);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors(), $request]);
        }

        $items_number = $request->page * 15;
        $temp = \App\Channel::findOrFail($id)->messages();
        $number_messages = count($temp->get());
        $load_more = (($items_number + 15) > $number_messages) ? false : true;

        $messages = $temp
            ->join('user', 'user.id', '=', 'message.user_id')
            ->select('user.username', 'date', 'content', 'photo_path')
            ->orderBy('date', 'desc')
            ->skip($items_number)->take(15) /*get last 15 rows */
            ->get();

        return response()->json([$messages, $load_more]);
    }

    public function show($project_id, $id = null)
    {
        $channels = Project::findOrFail($project_id)->channels()->get();
        $current_channel;

        if ($id === null) {
            $current_channel = (count($channels) > 0) ? $channels[0] : null;
        } else {
            $current_channel = \App\Channel::findorFail($id);
        }

        $messages = ($current_channel === null) ? null : $current_channel->messages()
            ->join('user', 'user.id', '=', 'message.user_id')
            ->select('user.username', 'date', 'content', 'photo_path')
            ->orderBy('date', 'desc')
            ->skip(0)->take(15) /*get last 15 rows */
            ->get()->reverse();

        return view('pages.chat', [
            'current_channel' => $current_channel,
            'channels' => $channels,
            'messages' => $messages,
            'project_id' => $project_id,
        ]);

    }
}