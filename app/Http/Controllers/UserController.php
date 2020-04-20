<?php

namespace App\Http\Controllers;

use App\User;

class UserController extends Controller
{
    public function index($id)
    {
        $users = User::all();
        dd($users);
        return view('pages.user.user');
    }

    public function projects($id)
    {
        return view('pages.user.projects');
    }
}
