<?php

namespace App\Http\Controllers;

class IssueController extends Controller
{
    public function show($id)
    {
        return view('pages.issue');
    }

    public function showList($id)
    {
        return view('pages.issueList');
    }

    public function showBoard($id)
    {
        return view('pages.issueBoard');
    }

    public function showUserIssues($id)
    {
        return view('pages.userIssues');
    }
}
