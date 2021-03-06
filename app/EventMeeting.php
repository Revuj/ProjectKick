<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class EventMeeting extends Model
{
    use Traits\HasCompositePrimaryKey;
    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'event_meeting';

    protected $primaryKey = array('event_id', 'project_id');

    public $incrementing = false;

    /**
     * Indicates if the model should be timestamped.
     *
     * @var bool
     */
    public $timestamps = false;

    public function event()
    {
        return $this->belongsTo(Event::class, 'event_id');
    }

    public function project()
    {
        return $this->belongsTo(Project::class, 'project_id');
    }
}
