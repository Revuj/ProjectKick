<?php

namespace App\Http\Controllers\User;

use App\Http\Controllers\Controller;
use App\Project;
use App\User;
use Illuminate\Support\Facades\Auth;
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
         $this->authorize('view', Project::find($id));
        return view('pages.project.overview');
    }

    public function members($id)
    {
        $this->authorize('checkMembers', Project::find($id));
        return view('pages.project.members');
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
