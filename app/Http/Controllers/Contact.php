<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class Contact extends Controller
{
    public function __invoke()
    {
        return view('pages.contact');
    }
}
