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

class ProjectController extends Controller
{
    public function activity($id)
    {
        $this->authorize('checkActivity', Project::find($id));
        return view('pages.project.activity');
    }

    public function index($id)
    {
        $project = Project::find($id);
        $this->authorize('view', $project);

        if ($project == null) {
            abort(404);
        }

        $author = User::find($project->author_id);

        return view('pages.project.overview', ['project' => $project, 'author' => $author]);
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
        $membership->user_id = $user->id;
        $membership->project_id = $id;
        // $membership->save();

        $user_id = $user->id;
        $sender_id = $request->input("senderId");

        $event = new Invitation($request->input('projectName'), $request->input('senderUsername'), $user_id, Carbon::now()->toDateTimeString());
        event($event);

        $notification = new Notification();
        $notification->date = Carbon::now()->toDateTimeString();
        $notification->description = "";
        $notification->receiver_id = $user_id;
        $notification->sender_id = $sender_id;
        $notification->save();

        $notificationKick = new NotificationInvite();
        $notificationKick->notification_id = $notification->id;
        $notificationKick->project_id = $id;
        $notificationKick->save();

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
        $notification->description = "";
        $notification->receiver_id = $user_id;
        $notification->sender_id = $sender_id;
        $notification->save();

        $notificationKick = new NotificationKick();
        $notificationKick->notification_id = $notification->id;
        $notificationKick->project_id = $id;
        $notificationKick->save();

        return $membership;
    }

    public function show($id)
    {
        $project = Project::findOrFail($id);
        $channelsDB = $project->channels();
        $channels = array();
        foreach ($channelsDB->get() as $channel) {
            $messages = $channel->messages()
                ->join('user', 'user.id', '=', 'message.user_id')
                ->select('user.username', 'date', 'content', 'photo_path')
                ->orderBy('date')->get();

            $channels[] = [
                'channel_id' => $channel->id,
                'channel_name' => $channel->name,
                'channel_description' => $channel->description,
                'messages' => $messages,
            ];

        }

        $first_channel = array_shift($channels);
        $project_id = $id;

        //dd($channels);
        return view('pages.chat', compact('first_channel', 'channels', 'project_id'));

    }
}
