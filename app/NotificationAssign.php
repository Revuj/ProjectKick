<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class NotificationAssign extends Model
{
    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'notification_assign';

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

    public function issue()
    {
        return $this->belongsTo(Project::class, 'issue_id');
    }
}
