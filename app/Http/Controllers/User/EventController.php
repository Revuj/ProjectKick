<?php

namespace App\Http\Controllers\User;

use App\Event;
use App\EventPersonal;
use App\Http\Controllers\Controller;
use App\User;
use Illuminate\Http\Request;

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

    public function create(Request $request)
    {
        //$this->authorize('create', new Event());

        $event = new Event();
        $event->title = $request->input('title');
        $event->start_date = $request->input('date');
        $type = $request->input('type');
        $event->save();

        if ($type == 'personal') {
            self::createPersonalEvent($event->id, $request->input('user'));
        } else if ($type == 'meeting') {
            //createMeetingEvent()
        }

        return $event;
    }
}
