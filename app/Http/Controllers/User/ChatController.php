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

        /*
        Validator::make($request->all(), [
        'name' => 'required|max:255'
        ])->validate(); */

        $chat = Channel::create([
            'name' => $request->input('name'),
            'description' => $request->input('description'),
            'creation_date' => Carbon::now()->toDateTimeString(),
            'project_id' => $id,
        ]);

        return response()->json([$chat]);

        //$users = Project::find($id)->memberStatus()->join('user', 'user.id', '=', 'member_status.project_id');
        //event(new ChatCreated($id));

    }

    public function delete($id)
    {
        //verificar se é coordenador
        $channel = Channel::find($id);

        //$this->authorize('delete', $channel);
        if ($channel == null) {
            abort(404);
        }

        $channel->delete($id);

        return $channel;
    }

}
