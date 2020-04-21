<?php

namespace App\Http\Controllers\User;
use App\Http\Controllers\Controller;

use Illuminate\Http\Request;

class ProjectController extends Controller
{
    public function activity($project_id)
    {
        return view('pages.project.activity');
    }

    public function index($project_id)
    {
        return view('pages.project.overview');
    }

    public function members($project_id)
    {
        return view('pages.project.members');    
    }

}
