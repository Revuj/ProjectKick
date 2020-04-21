<?php

namespace App\Http\Controllers\User;
use App\Http\Controllers\Controller;


class IssueController extends Controller
{
    public function show($id)
    {
        return view('pages.issue');
    }

    public function showList($id)
    {
        return view('pages.issue-list');
    }

    public function showBoard($id)
    {
        return view('pages.issue-board');
    }

    public function showUserIssues($id)
    {
        return view('pages.user-issues');
    }
}