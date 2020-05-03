<?php

namespace App\Http\Controllers\User;

use App\Http\Controllers\Controller;
use App\User;
use DB;
use Illuminate\Auth\Access\Response;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Database\QueryException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class UserController extends Controller
{
    public function profile($id)
    {
        $this->authorize('view', User::findOrFail($id));
        // depende se queremos mostrar o perfil de utilizadores apagados ou não
        $user = User::withTrashed()->find($id);
        if ($user == null) {
            abort(404);
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
        $description = $user->description;
        $photo_path = $user->photo_path;

        return view('pages.user.profile', ['username' => $username, 'user_id' => $user_id, 'user' => $user, 'first_name' => $first_name, 'last_name' => $last_name, 'email' => $email, 'phone_number' => $phone_number, 'country' => $country, 'assigned_issues' => $assigned_issues, 'completed_issues' => $completed_issues, 'projects' => $projects->get(), 'closed_projects' => $closed_projects, 'open_projects' => $open_projects, 'description' => $description, 'photo_path' => $photo_path]);
    }

    public function update(Request $request, $id)
    {
        $this->authorize('own', User::findOrFail($id));

        try {
            $user = User::findOrFail($id);
            $user->username = $request->input('username');
            $user->name = $request->input('firstName') . ' ' . $request->input('lastName');
            $user->email = $request->input('email');
            $user->phone_number = $request->input('phone');
            $user->description = $request->input('description');
            $password = $request->input('password');
            if (strlen($password) > 0) {
                if ($password == $request->input('confirmPassword')) {
                    $user->password = password_hash($password, PASSWORD_DEFAULT);
                } else {
                    return response()->json([
                        'message' => 'Passwords dont match.',
                    ], 400);
                }
            }

            $user->save();
            return $user;
        } catch (ModelNotFoundException $err) {
            return response()->json([], 404);
        } catch (QueryException $err) {
            if ($err->getCode() == 23514) {
                return response()->json([
                    'message' => 'Invalid password length.',
                ], 400);
            } else if ($err->getCode() == 23505) {
                return response()->json([
                    'message' => 'Invalid username/email.',
                ], 400);
            }
        }
    }

    public function updatePhoto(Request $request, $id)
    {
        $this->authorize('own', User::findOrFail($id));

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
                "photo" => $user->photo_path,
            ], 200);
        } catch (ModelNotFoundException $err) {
            return response()->json([], 404);
        } catch (QueryException $err) {
            return response()->json([
                'message' => 'Unable to update profile photo',
            ], 400);
        }
    }

    public function delete($id)
    {
        $this->authorize('own', User::findOrFail($id));

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
        $this->authorize('own', User::findOrFail($id));

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
            ->select('project.id', 'project.name', 'project.creation_date', 'project.finish_date', 'project.description', 'project.search')
            ->paginate(6);

        $editable = true; // while authentication is not implemented
        return view('pages.user.projects', ['editable' => $editable, 'projects' => $projects, 'user_id' => $id, 'user_photo_path' => $user->photo_path]);
    }

    private function sortFunction($projects, $sortableTrait, $order = 'ASC')
    {

        $sortCol = 'project.';
        if ($sortableTrait === 'Opening Date') {
            $sortCol = $sortCol . 'creation_date';
        } else if ($sortableTrait === 'Due Date') {
            $sortCol = $sortCol . 'finish_date';
        } else if ($sortableTrait === 'Name') {
            $sortCol = $sortCol . 'name';
        } else {
            return $projects;
        }

        return $projects->orderBy($sortCol, $order);
    }

    private function filterResults($projects, $request)
    {
        $search = $request->input('search');

        if (!empty($search)) {
            return $projects::FTS($search);
        }

        return $projects;
    }

    public function fetchSort(Request $request, $id)
    {

        $sortableTrait = $request->input('option');
        $order = ($request->input('order') === 'true') ? 'ASC' : 'DESC';

        $user = User::find($id);
        $projects = $user->projectsStatus()
            ->join('project', 'project.id', '=', 'member_status.project_id')
            ->join('user', 'user.id', '=', 'project.author_id')
            ->select('project.id', 'project.name', 'project.creation_date', 'project.finish_date', 'project.description', 'project.search');

        $filter = $this->filterResults($projects, $request);
        $sorted = $this->sortFunction($filter, $sortableTrait, $order);

        return response()->json($sorted->get());
    }

    protected function filterProjects(Request $request, $id)
    {
        $user = User::find($id);
        $search = $request->input('search');
        $projects = $user->projectsStatus()
            ->join('project', 'project.id', '=', 'member_status.project_id')
            ->join('user', 'user.id', '=', 'project.author_id')
            ->whereRaw("project.search @@ plainto_tsquery('english', ?)", [$search])
            ->select('project.id');

        return $projects->get();
    }

    public function calendar($id)
    {
        $this->authorize('own', User::findOrFail($id));

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

        $editable = true; // while authentication is not implemented
        return view('pages.user.calendar', ['user_id' => $id]);
    }

    public function events(Request $request, $id)
    {
        $this->authorize('own', User::findOrFail($id));
        $user = User::find($id);
        if ($user == null) {
            abort(404);
        }
        $month = $request->input("month");
        $year = $request->input("year");
        $events = DB::table('event_personal')
            ->join('event', 'event.id', '=', 'event_personal.event_id')
            ->where('event_personal.user_id', '=', $id)
            ->select('event.title', 'event.start_date');

        return $events->get();
    }

}
