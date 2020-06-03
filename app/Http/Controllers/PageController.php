<?php

namespace App\Http\Controllers;

class PageController extends Controller
{
    public function index()
    {
        return view('pages.homepage');
    }

    public function contact()
    {
        return view('pages.contact');
    }

    public function about()
    {
        return view('pages.about');
    }

    public function authenticate()
    {
        return view('pages.authenticate');
    }

    public function help(){
        return view('pages.help');
    } 

}