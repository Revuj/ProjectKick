<?php

namespace App\Http\Controllers;

class ChatController extends Controller
{
    public function show($id)
    {
        return view('pages.chat');
    }
}
