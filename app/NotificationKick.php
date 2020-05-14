<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class NotificationKick extends Model
{

    protected $appends = ['typeofNotification'];

    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'notification_kick';

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

    public function project()
    {
        return $this->belongsTo(Project::class, 'project_id');
    }

    public function getTypeOfNotificationAttribute() {
        return 'kick';
    }
}
