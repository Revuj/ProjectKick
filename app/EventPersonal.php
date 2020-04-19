<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class EventPersonal extends Model
{
    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'event_personal';

    protected $with = ['event', 'user'];

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

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }
}
