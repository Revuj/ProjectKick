<?php

namespace App\Http\Controllers\User;
use App\Http\Controllers\Controller;


use App\User;
use Validator;
use Auth;


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
