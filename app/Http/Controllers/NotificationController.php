<?php

namespace App\Http\Controllers;

class NotificationController extends Controller
{
    public function show($id)
    {
        return view('pages.notifications');
    }
}
