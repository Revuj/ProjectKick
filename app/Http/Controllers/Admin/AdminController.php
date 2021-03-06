<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Issue;
use App\Project;
use App\Report;
use App\User;
use Carbon\Carbon;
use Illuminate\Auth\Access\Response;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class AdminController extends Controller
{
    public function dashboard($id)
    {
        $projects = count(Project::all());
        $closed_tasks = count(Issue::where('is_completed', '=', 'true')->get());
        $user_number = count(User::all());
        $nr_reports = count(Report::all());
        return view('pages.admin.dashboard', [
            'projects' => $projects,
            'closed_tasks' => $closed_tasks,
            'nr_users' => $user_number,
            'nr_reports' => $nr_reports,
        ]);
    }

    public function fetchCountries(Request $request)
    {
        $users_per_country = User::join('country', 'country_id', '=', 'country.id')
            ->select('country.name', DB::raw('count(*) as total'))
            ->groupBy('country.name')->get();

        return response()->json([$users_per_country]);
    }

    public function reports()
    {

        $reports = \App\Report::all()->map(function ($r) {
            $r['sender'] = User::find($r->reports_id)['username'];
            $r['receiver'] = User::find($r->reported_id)['username'];
            return $r;
        })->sortbyDesc('id');

        return view('pages.admin.reports', [
            'admin_id' => \Auth::Id(),
            'reports' => $reports,
        ]);
    }

    public function fetchIntelPerMonth(Request $request)
    {
        $now = new Carbon();
        $firstDay = $now->firstOfMonth();
        $aYearAgo = $firstDay->clone()->subYears(1)->format("Y-m-d H:i:s");

        $issues = Issue::where('creation_date', '>=', $aYearAgo)
            ->where('creation_date', '<=', $now)
            ->select(DB::raw('count(id) as total'),
                DB::raw("extract(month from creation_date) as month"),
                DB::raw("extract(year from creation_date) as year")
            )
            ->groupby('year', 'month')
            ->orderby('month')
            ->get();

        $projects = Project::where('creation_date', '>=', $aYearAgo)
            ->where('creation_date', '<=', $now)
            ->select(DB::raw('count(id) as total'),
                DB::raw("extract(month from creation_date) as month"),
                DB::raw("extract(year from creation_date) as year")
            )
            ->groupby('year', 'month')
            ->orderby('month')
            ->get();

        $users = User::where('creation_date', '>=', $aYearAgo)
            ->where('creation_date', '<=', $now)
            ->select(DB::raw('count(id) as total'),
                DB::raw("extract(month from creation_date) as month"),
                DB::raw("extract(year from creation_date) as year")
            )
            ->groupby('year', 'month')
            ->orderby('month')
            ->get();

        return response()->json([$issues, $projects, $users]);

    }

    public function bannedUsers(Request $request)
    {
        $users = User::where('is_banned', '=', 'true')->get();
        return response()->json([$users]);
    }

    public function recentUsers(Request $request)
    {
        $users = User::orderby('creation_date', 'desc')
            ->take(5)
            ->get();

        return response()->json([$users]);
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

    public function fetchProjects(Request $request)
    {

        $request['order'] = filter_var($request['order'], FILTER_VALIDATE_BOOLEAN);

        $rules = [
            'option' => 'required|string',
            'search' => 'string|nullable',
            'order' => 'required|boolean',
        ];

        $validator = Validator::make($request->all(), $rules);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors(), $request]);

        }

        $filter = $this->filterProjects($request);
        $sortableTrait = $request->input('option');

        $order = ($request->input('order') === true) ? 'ASC' : 'DESC';
        $sort = $this->sortFunction($filter, $sortableTrait, $order);

        $sorted = $sort->get()->map(function ($project) {
            $issues = $project->issues();
            $project['nr_issues'] = count($issues->get());
            $nr_open = count($issues->where('is_completed', '=', 'false')->get());
            $project['nr_open_issues'] = $nr_open;
            return $project;
        });

        return response()->json([
            $sorted,
        ]);
    }

    public function fetchUsers(Request $request)
    {
        $request['order'] = filter_var($request['order'], FILTER_VALIDATE_BOOLEAN);

        $rules = [
            'option' => 'required|string',
            'search' => 'string|nullable',
            'order' => 'required|boolean',
        ];

        $validator = Validator::make($request->all(), $rules);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors(), $request]);
        }

        $filter = $this->filterUsers($request);
        $sortableTrait = $request->input('option');

        $order = ($request->input('order') === true) ? 'ASC' : 'DESC';
        $sorted = $this->sortUsers($filter, $sortableTrait, $order);

        return response()->json([
            $sorted->get(),
        ]);
    }

    private function sortUsers($users, $sortableTrait, $order = 'ASC')
    {

        $sortCol = 'user.';
        if ($sortableTrait === 'Creation Date') {
            $sortCol = $sortCol . 'creation_date';
        } else if ($sortableTrait === 'Username') {
            $sortCol = $sortCol . 'username';
        } else if ($sortableTrait === 'Email') {
            $sortCol = $sortCol . 'email';
        } else if ($sortableTrait === 'Banned') {
            return $users->where('is_banned', '=', 'true');
        } else {
            return $users;
        }

        return $users->orderBy($sortCol, $order);
    }

    protected function filterUsers($request)
    {
        $search = $request->input('search');
        if (!empty($search)) {
            $projects = User::where('is_admin', '=', 'false')
                ->whereRaw("search @@ plainto_tsquery('english', ?)", [$search]);
        } else {
            $projects = User::where('is_admin', '=', 'false');
        }
        return $projects;
    }

    protected function filterProjects($request)
    {
        $search = $request->input('search');
        if (!empty($search)) {
            $projects = Project::whereRaw("project.search @@ plainto_tsquery('english', ?)", [$search]);
        } else {
            $projects = new Project();
        }
        return $projects;
    }

    public function banUser(Request $request, $id)
    {

        $user = User::findOrFail($id);
        $user->is_banned = true;
        $user->save();
        return response()->json([]);
    }

    public function unbanUser(Request $request, $id)
    {

        $user = User::findOrFail($id);
        $user->is_banned = false;
        $user->save();
        return response()->json([]);
    }

    public function deleteProject($id)
    {
        $res = Project::findOrFail($id)->delete();
        return response()->json([$res]);
    }

    public function fetchNrProjects(Request $request)
    {
        $nr_projects = count(Project::all());
        return response()->json([$nr_projects]);
    }

    public function fetchNrTasks(Request $request)
    {
        $closed_tasks = count(Issue::where('is_completed', '=', 'true')->get());
        return response()->json([$closed_tasks]);
    }

    public function fetchNrUsers(Request $request)
    {
        $user_number = count(User::all());
        return response()->json([$user_number]);
    }

    public function fetchNrReports(Request $request)
    {
        $nr_reports = count(Report::all());
        return response()->json([$nr_reports]);
    }

    public function fetchByTeamSize()
    {

        $projects = Project::join('member_status', 'member_status.project_id', '=', 'project.id')
            ->select('project.id', DB::raw('count(*) as total'))
            ->groupBy('project.id')
            ->get();

        $groups = [
            'small' => 0,
            'medium' => 0,
            'large' => 0,
        ];

        foreach ($projects as $project) {
            if ($project->total < 5) {
                $groups['small']++;
            } else if ($project->total > 20) {
                $groups['large']++;
            } else {
                $groups['medium']++;
            }
        }

        return response()->json([$groups]);

    }

    public function search()
    {
        $users = User::where('is_admin', '=', 'false')->get();
        $projects = Project::all();
        return view('pages.admin.search', [
            'users' => $users,
            'projects' => $projects,
        ]);
    }
}
