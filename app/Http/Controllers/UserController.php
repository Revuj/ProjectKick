<?php

namespace App\Http\Controllers;

use App\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class UserController extends Controller
{
    public function profile($id)
    {
        // depende se queremos mostrar o perfil de utilizadores apagados ou não
        $user = User::withTrashed()->find($id);
        if ($user == null) {
            abort(404);
        }

        // only lets authenticated user edit it's own profile
        $editable = true;
        if (!Auth::check()) {
            $editable = false;
        }
        $editable = true; // while authentication is not implemented

        $username = $user->username;
        $user_id = $user->id;
        $full_name = explode(' ', $user->name);
        $first_name = explode(' ', $user->name)[0];
        $last_name = "";
        if (count($full_name) > 1) {
            $last_name = explode(' ', $user->name)[1];
        }

        $email = $user->email;
        $phone_number = $user->phone_number;
        $country = $user->country->name;
        $assigned_issues = count($user->assignedIssues);
        $completed_issues = count($user->completedIssues);
        $projects = $user->projectsStatus()->join('project', 'project.id', '=', 'member_status.project_id');
        $projects_count = count($projects->get());
        $open_projects = count($projects->where('finish_date', null)->get());
        $closed_projects = $projects_count - $open_projects;
        $description = $user->description;
        $projects = $user->projectsStatus()->join('project', 'project.id', '=', 'member_status.project_id')->join('user', 'user.id', '=', 'project.author_id')->get();
        $photo_path = $user->photo_path;

        return view('pages.user.profile', ['editable' => $editable, 'username' => $username, 'user_id' => $user_id, 'first_name' => $first_name, 'last_name' => $last_name, 'email' => $email, 'phone_number' => $phone_number, 'country' => $country, 'assigned_issues' => $assigned_issues, 'completed_issues' => $completed_issues, 'projects' => $projects, 'closed_projects' => $closed_projects, 'open_projects' => $open_projects, 'description' => $description, 'photo_path' => $photo_path]);
    }

    public function update(Request $request, $id)
    {
        $user = User::find($id);

        if ($user == null) {
            abort(404);
        }

        $user->username = $request->input('username');
        $user->name = $request->input('firstName') . ' ' . $request->input('lastName');
        $user->email = $request->input('email');
        $user->phone_number = $request->input('phone');
        $user->description = $request->input('description');
        $password = $request->input('password');
        if (strlen($password) > 0) {
            if ($password == $request->input('confirmPassword')) {
                //calculate hash and update password
            } else {
                //passwords don't match
            }
        }

        $user->save();

        return $user;

    }

    public function updatePhoto(Request $request, $id)
    {        
        $folderPath = public_path('/assets/avatars/');

        $image_parts = explode(";base64,", $request->base64data);
        $image_type_aux = explode("image/", $image_parts[0]);
        $image_type = $image_type_aux[1];
        $image_base64 = base64_decode($image_parts[1]);
        $unique_id = uniqid();
        $file = $folderPath . $unique_id . '.png';

        file_put_contents($file, $image_base64);

        try {
            $user = User::findOrFail($id);
            $user->photo_path = $unique_id;    
            $user->save();
            return response()->json([
                "photo" => $user->photo_path
            ], 200);
        } catch (ModelNotFoundException $err) {
            return response()->json([], 404);
        } catch (QueryException $err) {
            return response()->json([], 400);
        }
    }

    public function delete($id)
    {
        $user = User::find($id);
        if ($user == null) {
            abort(404);
        }

        if (!Auth::check()) {
            // return redirect('/authenticate');
        }

        $user->delete($id);

        return $user;
    }

    public function projects($id)
    {

        $user = User::find($id);

        if ($user == null) {
            abort(404);
        }

        // only lets project coordinator edit the project
        // falta verificar se é o coordenador
        $editable = true;
        if (!Auth::check()) {
            $editable = false;
        }

        $projects = $user->projectsStatus()
            ->join('project', 'project.id', '=', 'member_status.project_id')
            ->join('user', 'user.id', '=', 'project.author_id')
            ->select('project.id', 'project.name', 'project.creation_date', 'project.finish_date', 'project.description', 'user.photo_path')
            ->get();

        $editable = true; // while authentication is not implemented
        return view('pages.user.projects', ['editable' => $editable, 'projects' => $projects, 'user_id' => $id]);
    }
}
