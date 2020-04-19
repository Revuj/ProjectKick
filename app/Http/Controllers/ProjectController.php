<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class ProjectController extends Controller
{
    public function activity($project_id)
    {
        return view('pages.project.activity');
    }

}
