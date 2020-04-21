<?php

namespace App\Http\Controllers\User;
use App\Http\Controllers\Controller;


class EventController extends Controller
{
    public function show($id)
    {
        return view('pages.calendar');
    }
}
