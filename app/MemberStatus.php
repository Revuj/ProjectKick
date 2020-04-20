<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

/**
 * id
 * role
 * entrance_date
 * departure_date
 * user_id
 * project_id
 */
class MemberStatus extends Model
{

    // Don't add create and update timestamps in database.
    public $timestamps = false;

    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'member_status';

    /**
     * @var array
     */
    protected $fillable = ['role', 'departure_date', 'user_id', 'project_id'];

    /**
     * @return
     */
    public function project()
    {
        return $this->hasOne(Project::class, 'id');
    }

    /**
     * @return
     */
    public function user()
    {
        return $this->hasOne(User::class, 'id');
    }

}
