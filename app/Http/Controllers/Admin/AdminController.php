<?php

namespace App\Http\Controllers\Admin;
use App\Http\Controllers\Controller;
use App\Project;
use App\Issue;
use App\User;
use App\Report;

use Illuminate\Auth\Access\Response;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Database\QueryException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;
use App\IssueList;


class AdminController extends Controller
{
    public function dashboard($id)
    {
        $projects = count(Project::all());
        $closed_tasks = count(Issue::where('is_completed','=', 'true')->get());
        $user_number = count(User::all());
        $nr_reports = count(Report::all());
        return view('pages.admin.dashboard' , [
            'projects' => $projects,
            'closed_tasks' => $closed_tasks,
            'nr_users' => $user_number,
            'nr_reports' => $nr_reports
        ]);
    }

    public function fetchCountries(Request $request) {
        $users_per_country = User::join('country', 'country_id', '=', 'country.id')
        ->select('country.name', DB::raw('count(*) as total'))
        ->groupBy('country.name')->get();

        return response()->json([$users_per_country]);
    }

    public function fetchIntelPerMonth(Request $request) {
        $now = new Carbon();   
        $firstDay = $now->firstOfMonth();     
        $aYearAgo = $firstDay->clone()->subYears(1)->format("Y-m-d H:i:s");

        $issues = Issue::where('creation_date','>=', $aYearAgo)
         ->select(DB::raw('count(id) as total'),
         DB::raw("extract(month from creation_date) as month"), 
         DB::raw("extract(year from creation_date) as year")
         )
        ->groupby('year', 'month')
        ->get();

        $projects = Project::where('creation_date','>=', $aYearAgo)
        ->select(DB::raw('count(id) as total'),
        DB::raw("extract(month from creation_date) as month"), 
        DB::raw("extract(year from creation_date) as year")
        )
       ->groupby('year', 'month')
       ->get();


       $users = User::where('creation_date','>=', $aYearAgo)
       ->select(DB::raw('count(id) as total'),
       DB::raw("extract(month from creation_date) as month"), 
       DB::raw("extract(year from creation_date) as year")
       )
      ->groupby('year', 'month')
      ->get();

        return response()->json([$issues, $projects, $users]);

    }

    public function bannedUsers(Request $request) {
        $users = User::where('is_banned','=', 'true')->get();
        return response()->json([$users]);
    }

    public function recentUsers(Request $request) {
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

    public function fetchProjects(Request $request) {

        
        $filter = $this->filterProjects( $request);
        $sortableTrait = $request->input('option');

        $order = ($request->input('order') === 'true') ? 'ASC' : 'DESC';
        $sorted = $this->sortFunction($filter, $sortableTrait, $order);
        

     
        return response()->json([
            $sorted->get()
        ]);
    }

    public function fetchUsers(Request $request) {
        $filter = $this->filterUsers($request);
        $sortableTrait = $request->input('option');

        $order = ($request->input('order') === 'true') ? 'ASC' : 'DESC';
        $sorted = $this->sortUsers($filter, $sortableTrait, $order);


        return response()->json([
            $sorted->get()
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
        }else if ($sortableTrait === 'Banned') {
            return $users->where('is_banned', '=', 'true');
        }
         else {
            return $users;
        }

        return $users->orderBy($sortCol, $order);
    }

    protected function filterUsers($request)
    {
        $search = $request->input('search');
        if (!empty($search))
            $projects = User::where('is_admin','=','false')
            ->whereRaw("search @@ plainto_tsquery('english', ?)", [$search]);
        else {
            $projects = User::where('is_admin','=','false');
        }
        return $projects;
    }

    protected function filterProjects($request)
    {
        $search = $request->input('search');
        if (!empty($search))
            $projects = Project::whereRaw("project.search @@ plainto_tsquery('english', ?)", [$search]);
        else {
            $projects = new Project();
        }
        return $projects;
    }

    public function banUser(Request $request, $id) {
        
        return response()->json([$id]);
    }

    public function unbanUser(Request $request, $id) {
        
        return response()->json([$id]);
    }

    public function search()
    {
        $users = User::where('is_admin','=','false')->get();
        $projects = Project::all();
        return view('pages.admin.search', [
            'users' => $users,
            'projects' => $projects
        ]);
    }
}
