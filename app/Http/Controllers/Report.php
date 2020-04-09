<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class Report extends Controller
{
    public function __invoke()
    {
        return view('pages.report');
    }
}
