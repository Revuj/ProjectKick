<?php

namespace App\Http\Controllers\User;

use App\Http\Controllers\Controller;
use App\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class NotificationController extends Controller
{

    public function show($id)
    {
        return view('pages.notifications');
    }

    public function authorizeUser(Request $request)
    {

        if (!Auth::check()) {

            return new Response('Forbidden', 403);

        }

        $pusher = new \Pusher\Pusher(config('broadcasting.connections.pusher.key'), config('broadcasting.connections.pusher.secret'), config('broadcasting.connections.pusher.app_id'));

        echo $pusher->socket_auth(

            $request->input('channel_name'),

            $request->input('socket_id')

        );

    }
}
