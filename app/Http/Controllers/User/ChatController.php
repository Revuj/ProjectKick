<?php

namespace App\Http\Controllers\User;

class ChatController extends Controller
{
    public function show($id)
    {
        return view('pages.chat');
    }
}
