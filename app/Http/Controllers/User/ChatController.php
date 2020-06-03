<?php

namespace App\Http\Controllers\User;

use App\Channel;
use App\Http\Controllers\Controller;
use App\User;
use Carbon\Carbon;
use Illuminate\Auth\Access\Response;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class ChatController extends Controller
{

    protected function validator(array $data)
    {
        return Validator::make($data, [
            'name' => 'required|string|max:255',
            'description' => 'string|max:255',
            'project_id' => 'required|integer',
        ]);
    }

    public function create(Request $request, $id)
    {
        $rules = [
            'name' => 'required|string|max:255',
            'description' => 'string|nullable' 
        ];
        
        $messages = [
            'name.required' => 'You have to give a name to your channel'
        ];

        $validator = Validator::make($request->all(), $rules, $messages);

        if ($validator->fails()) {
            return response()->json(['errors'=>$validator->errors(), $request]);
        }
        

        $chat = Channel::create([
            'name' => $request->input('name'),
            'description' => $request->input('description'),
            'creation_date' => Carbon::now()->toDateTimeString(),
            'project_id' => $id,
        ]);

        return response()->json([$chat]);

    }

    public function delete($id)
    {
        //verificar se é coordenador
        $channel = Channel::findOrFail($id);

        //$this->authorize('delete', $channel);


        $channel->delete($id);

        return $channel;
    }

}