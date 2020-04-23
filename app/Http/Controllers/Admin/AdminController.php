<?php

namespace App\Http\Controllers\Admin;
use App\Http\Controllers\Controller;


class AdminController extends Controller
{
    public function dashboard($id)
    {
        return view('pages.admin.dashboard');
    }

    public function search()
    {
        return view('pages.admin.search');
    }
}
