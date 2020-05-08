<?php

namespace App\Http\Controllers\User;

use App\Http\Controllers\Controller;
use App\MemberStatus;
use App\Project;
use App\User;
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

        $username = $request->input("username");
        $role = $request->input("role");
        $user = User::where("username", "=", $username)->first();

        // estou a adicionar logo mas no futuro deveria ser um convite
        $membership = new MemberStatus();
        $membership->role = $role;
        $membership->user_id = $user->id;
        $membership->project_id = $id;

        $membership->save();

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
        $membership = MemberStatus::where("user_id", "=", $user_id)->where("project_id", "=", $id)->first();
        $membership->delete();

        return $membership;
    }

    public function show($id)
    {
        $project = Project::findOrFail($id);
        $channelsDB = $project->channels();
        $channels = array();
        foreach($channelsDB->get() as $channel) {
            $messages = $channel->messages()
            ->join('user', 'user.id', '=', 'message.user_id')
            ->select('user.username', 'date', 'content', 'photo_path')
            -> orderBy('date')->get();

            $channels[]  =  [ 
                'channel_id' => $channel->id,
                'channel_name' => $channel->name,
                'channel_description' => $channel->description,
                'messages' => $messages
            ];

        }

        $first_channel = array_shift($channels);
        $project_id = $id;


        //dd($channels);
        return view('pages.chat', compact('first_channel', 'channels', 'project_id'));
      
    }   

}
