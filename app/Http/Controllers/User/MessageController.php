<?php

namespace App\Http\Controllers\User;

use App\Events\MessageEvent;
use App\Http\Controllers\Controller;
use App\Message;
use App\User;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class MessageController extends Controller
{

    public function create(Request $request, $id)
    {

        $message = new Message();
        $message->content = $request->input('content');
        $message->date = Carbon::now()->toDateTimeString();
        $message->channel_id = $request->input('channel_id');
        $message->user_id = Auth::id();
        $user = User::select('username', 'photo_path')
            ->where('id', $message->user_id)->first();

        $event = new MessageEvent($message);

        event($event);

        $message->save();

        return response()->json([
            $message, $user,
        ]);

    }

}
