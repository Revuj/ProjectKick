<?php

namespace App\Http\Controllers\User;
use App\Http\Controllers\Controller;
use Carbon\Carbon;

use App\Channel;
use App\Project;
use App\User;

use Illuminate\Http\Request;
use Illuminate\Auth\Access\Response;
use Illuminate\Support\Facades\Validator;



class ChatController extends Controller
{

    public function create(Request $request, $id) {

        /*
        Validator::make($request->all(), [
            'name' => 'required|max:255'
        ])->validate(); */
       

        try {
            $chat = new Channel();
            $chat->name = $request->input('name');
            $chat->description = $request->input('description');
            $chat->creation_date = Carbon::now()->toDateTimeString();
            $chat->project_id = $id;

            $chat->save();
            return response()->json([
                $chat
            ]);

        } catch (ModelNotFoundException $err) {
            return response()->json([], 404);
        } catch (QueryException $err) {
            return response()->json([
                'message' => 'Unable to create a new chat',
            ], 400);
        }
    }

}
