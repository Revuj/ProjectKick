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

    public function search()
    {
        return view('pages.admin.search');
    }
}
