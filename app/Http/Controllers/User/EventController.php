<?php

namespace App\Http\Controllers\User;

use App\Event;
use App\EventMeeting;
use App\EventPersonal;
use App\Events\Meeting;
use App\Http\Controllers\Controller;
use App\MemberStatus;
use App\Notification;
use App\NotificationEvent;
use App\Project;
use App\User;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class EventController extends Controller
{
    public function show($id)
    {
        $this->authorize('own', User::findOrFail($id));
        return view('pages.calendar');
    }

    public function createPersonalEvent($event, $user)
    {
        $this->authorize('own', User::findOrFail($user));

        $personalEvent = new EventPersonal();
        $personalEvent->event_id = $event;
        $personalEvent->user_id = $user;
        $personalEvent->save();
    }

    public function createMeetingEvent($event, $project_id, $sender_id)
    {
        $meetingEvent = new EventMeeting();
        $meetingEvent->event_id = $event;
        $meetingEvent->project_id = $project_id;

        $this->authorize('create', $meetingEvent);
        $meetingEvent->save();

        $sender = User::findOrFail($sender_id);
        $project = Project::findOrFail($project_id);

        $members = MemberStatus::where("project_id", "=", $project_id)->get();
        foreach ($members as $member) {
            $assignment = new Meeting(
                $project->name,
                $sender->username,
                $member->user_id,
                Carbon::now()->toDateTimeString(),
                $sender->photo_path,
                $project_id
            );
            event($assignment);

            DB::beginTransaction();
            $notification = new Notification();
            $notification->date = Carbon::now()->toDateTimeString();
            $notification->receiver_id = 1;
            $notification->sender_id = 2;
            $notification->save();

            $notificationEvent = new NotificationEvent();
            $notificationEvent->notification_id = $notification->id;
            $notificationEvent->event_id = $event->id;
            $notificationEvent->save();
            DB::commit();
        }
    }

    public function create(Request $request)
    {
        $rules = [
            'title' => 'required|string|min:1|max:30',
            'type' => 'required|string',
            'date' => 'required|date',
            'id' => 'required|integer',
        ];

        $messages = [
            'max' => 'Event name too large',
            'required' => ":attribute is required. Please specify one",
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

        $sender_id = $request->input("sender");

        if ($type == 'personal') {
            $this->createPersonalEvent($event->id, $id);
        } else if ($type == 'meeting') {
            $this->createMeetingEvent($event->id, $id, $sender_id);
        }

        return response()->json([
            'title' => $event->title,
            'start_date' => $event->start_date,
        ], 200);
    }
}
