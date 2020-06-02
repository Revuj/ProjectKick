<?php

namespace App\Http\Controllers\User;

use App\Events\MessageEvent;
use App\Http\Controllers\Controller;
use App\Message;
use App\User;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;


class MessageController extends Controller
{

    public function create(Request $request, $id)
    {   
        $request['user_id'] = \Auth::Id();

        $rules = [
            'content' => 'required|string|max:200|min:1',
            'channel_id' => 'required|integer|exists:channel,id',
            'user_id'    => 'required|integer|exists:user,id',
        ];

        $messages = [
            'content.required' => 'The message can not be empty'
        ];

        $validator = Validator::make($request->all(), $rules, $messages);

        if ($validator->fails()) {
            return response()->json(['errors'=>$validator->errors(), $request]);
        }   
        

        $message = Message::create([
            'user_id' =>$request->user_id,
            'channel_id' => $request->channel_id,
            'content' => $request['content'],
        ])->refresh();


        $user = User::select('username', 'photo_path')
            ->where('id', $message->user_id)->first();
        
        $event = new MessageEvent(
            $request->input('channel_id'),
            $request->input('content'),
            $user['photo_path'],
            $user['username'],
            $message->date
        );

        event($event);
        
        return response()->json([
            $message, $user,
        ]);

    }

}