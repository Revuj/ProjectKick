<?php

namespace App\Http\Controllers\User;
use App\Http\Controllers\Controller;
use Illuminate\Auth\Access\Response;



use App\User;
use Validator;
use Auth;


class UserController extends Controller
{
    // cannot see admins
    public function index($id)
    {
        $this->authorize('view', [User::findOrFail($id), User::class]);
        $users = User::all();
        return view('pages.user.user');
    }

    // can only see its projects
    public function projects($id)
    {
        $this->authorize('own', [ User::findOrFail($id), User::class]);

        return view('pages.user.projects');
    }


}
