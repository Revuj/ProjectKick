<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class NotificationEvent extends Model
{
    protected $appends = ['typeofNotification'];

    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'notification_event';

    public $incrementing = false;

    /**
     * Indicates if the model should be timestamped.
     *
     * @var bool
     */
    public $timestamps = false;

    public function notification()
    {
        return $this->belongsTo(Notification::class, 'notification_id');
    }

    public function event()
    {
        return $this->belongsTo(Event::class, 'event_id');
    }

    public function getTypeOfNotificationAttribute()
    {
        return 'event';
    }
}
