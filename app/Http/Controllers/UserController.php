<?php

namespace App\Http\Controllers;

use App\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class UserController extends Controller
{
    public function profile($id)
    {
        $user = User::find($id);
        if ($user == null) {
            abort(404);
        }

        $editable = true;
        if (!Auth::check()) {
            $editable = false;
        }

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

        return view('pages.user.profile', ['username' => $username, 'user_id' => $user_id, 'first_name' => $first_name, 'last_name' => $last_name, 'email' => $email, 'phone_number' => $phone_number, 'country' => $country, 'assigned_issues' => $assigned_issues, 'completed_issues' => $completed_issues, 'closed_projects' => $closed_projects, 'open_projects' => $open_projects]);
    }

    public function projects($id)
    {
        return view('pages.user.projects');
    }

    public function update(Request $request, $id)
    {
        $user = User::find($id);

        if ($user == null) {
            abort(404);
        }

        $user->name = $request->input('firstName') . ' ' . $request->input('lastName');
        $user->email = $request->input('email');
        $user->phone_number = $request->input('phone');

        $user->save();

        return $user;

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
}
