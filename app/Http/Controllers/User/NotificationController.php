<?php

namespace App\Http\Controllers\User;
use App\Http\Controllers\Controller;

class NotificationController extends Controller
{
    public function show($id)
    {
        return view('pages.notifications');
    }
}
