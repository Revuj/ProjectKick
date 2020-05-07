<?php

namespace App\Http\Controllers\User;

use App\Http\Controllers\Controller;
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

}
