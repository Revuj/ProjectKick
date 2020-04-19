<?php

namespace App\Http\Controllers;

class EventController extends Controller
{
    public function show($id)
    {
        return view('pages.calendar');
    }
}
