<?php

namespace App\Http\Controllers\User;

use App\Event;
use App\EventPersonal;
use App\EventMeeting;
use App\Http\Controllers\Controller;
use App\User;
use Illuminate\Database\QueryException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;


class EventController extends Controller
{
    public function show($id)
    {
        return view('pages.calendar');
    }

    public function createPersonalEvent($event, $user)
    {
        $personalEvent = new EventPersonal();
        $personalEvent->event_id = $event;
        $personalEvent->user_id = $user;
        $personalEvent->save();
    }

    public function createMeetingEvent($event, $project)
    {
        $meetingEvent = new EventMeeting();
        $meetingEvent->event_id = $event;
        $meetingEvent->project_id = $project;

        $this->authorize('create', $meetingEvent);
        $meetingEvent->save();
    }

    public function create(Request $request)
    {
        $rules = [
            'title' => 'required|string|min:1|max:30',
            'type' => 'required|string',
            'date' => 'required|date',
            'id' => 'required|integer'
        ];

        $messages = [
            'max' => 'Event name too large',
            'required' => ":attribute is required. Please specify one"
        ];

        $validator = Validator::make($request->all(), $rules, $messages);

        if ($validator->fails()) {
            return response()->json(['errors' => $validator->errors()], 404);
        }

        $event = new Event();
        $event->title = $request->title;
        $event->start_date = $request->date;
        $event->save();

        $type = $request->type;
        $id = $request->id;

        if ($type == 'personal') {
            $this->createPersonalEvent($event->id, $id);
        } else if ($type == 'meeting') {
            $this->createMeetingEvent($event->id, $id);
        }

        return response()->json([
            'title' => $event->title,
            'start_date' => $event->start_date
        ], 200);
    }
}
