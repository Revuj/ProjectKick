<?php

namespace App\Http\Controllers;

class IssueController extends Controller
{
    public function show($id)
    {
        return view('pages.issue');
    }
}
